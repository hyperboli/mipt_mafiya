import "dart:math"; // for randomness purposes
import "dart:io"; // for debug purposes 

enum Role {
  none, citizen, mafia, godfather, sheriff, doctor, prostitute, murderer, jester,
}

class Player {
  int number  = 0;
  Role role   = Role.none;
  bool alive  = true;
  int choice = 0;
  
  Player(this.number);

  void debugPrint() {
    stdout.writeln("Player #$number: $role, alive = $alive, choice = $choice");
  }
}

class Game {
  final Rules rules;
  final int playerAmount;
  final int mafiaAmount;
  int curPlayerAmount;
  int curMafiaAmount;
  int doctorSelfHealsLeft;
  int doctorPrevChoice = 0;
  int prostitutePrevChoice = 0;
  int visitedByProstitute = 0;
  int discussionStartsFrom = 1;
  List<int> phaseVictims = List<int>.empty(growable: true);
  List<Player> players;

  Game(this.rules) :
    players = List<Player>.generate(rules.playerAmount, (index) => Player(index + 1)),
    playerAmount = rules.playerAmount,
    curPlayerAmount = rules.playerAmount,
    mafiaAmount = rules.mafiaAmount,
    curMafiaAmount = rules.mafiaAmount,
    doctorSelfHealsLeft = rules.selfHealingLimit {
    distributeRoles();
  }

  void distributeRoles() {
    Random random = Random(DateTime.now().microsecondsSinceEpoch);
    int playersLeft = playerAmount;
    if (rules.godfather && playersLeft > 0) {
      assignRole(Role.godfather, random.nextInt(playersLeft--));
    }
    if (rules.sheriff && playersLeft > 0) {
      assignRole(Role.sheriff, random.nextInt(playersLeft--));
    }
    if (rules.doctor && playersLeft > 0) {
      assignRole(Role.doctor, random.nextInt(playersLeft--));
    }
    if (rules.prostitute && playersLeft > 0) {
      assignRole(Role.prostitute, random.nextInt(playersLeft--));
    }
    if (rules.murderer && playersLeft > 0) {
      assignRole(Role.murderer, random.nextInt(playersLeft--));
    }
    if (rules.jester && playersLeft > 0) {
      assignRole(Role.jester, random.nextInt(playersLeft--));
    }
    for (int i = 0; i < (rules.godfather ? mafiaAmount - 1: mafiaAmount) && playersLeft > 0; i++) {
      assignRole(Role.mafia, random.nextInt(playersLeft--));
    }
    while (playersLeft > 0) {
      assignRole(Role.citizen, random.nextInt(playersLeft--));
    }
  }

  void assignRole(Role role, int index) {
    int realIndex;
    for (realIndex = 0; players[realIndex].role != Role.none || index != 0; realIndex = (realIndex + 1) % playerAmount) {
      if (players[realIndex].role == Role.none) {
        index--;
      }
    }
    players[realIndex].role = role;
    players[realIndex].number = realIndex + 1; // excessive
  }

  void eraseChoices() {
    for (int index = 0; index < playerAmount; index++) {
      players[index].choice = 0;
    }
  }

  int getFinalMafiaTarget() { // 0 for none
    List<int> targets = List<int>.filled(playerAmount, 0);
    for (Player player in players) {
      if (player.alive && ((player.role == Role.mafia) || (player.role == Role.godfather)) && player.choice != 0) {
        targets[player.choice - 1]++;
      }
    }
    int maxVotes = 0;
    int mostVotedNumber = 0;
    for (int number = 1; number <= playerAmount; number++) {
      if (targets[number - 1] > maxVotes) {
        mostVotedNumber = number;
        maxVotes = targets[mostVotedNumber - 1];
      }
    }
    if (maxVotes == 0) {
      return 0;
    }
    if (rules.unanimousKilling) {
      if (targets[mostVotedNumber - 1] != curMafiaAmount) {
        return 0;
      }
    } else {
      if (targets[mostVotedNumber - 1] <= curMafiaAmount ~/ 2) {
        return 0;
      }
      if ((players[mostVotedNumber - 1].role == Role.mafia || players[mostVotedNumber - 1].role == Role.godfather)) {
        if (players[mostVotedNumber - 1].choice != mostVotedNumber) {
          return 0;
        }
      }
    }
    return mostVotedNumber;
  } 

  int getFinalRoleTarget(Role role) { // 0 for none
    int choice = 0;
    for (Player player in players) {
      if (player.role == role && player.alive) {
        choice = player.choice;
        players[player.number - 1].choice = 0; // excessive
        if (player.role == Role.doctor) {
          int prevChoice = doctorPrevChoice;
          doctorPrevChoice = choice;
          if (!rules.repeatedHealing && prevChoice == choice) {
            return 0;
          }
          if (choice == player.number) {
            if (!rules.selfHealing) {
              return 0;
            } else if (rules.selfHealingLimited) {
              if (doctorSelfHealsLeft > 0) {
                doctorSelfHealsLeft--;
              } else {
                return 0;
              }
            }
          }
        }
        if (player.role == Role.prostitute) {
          int prevChoice = prostitutePrevChoice;
          prostitutePrevChoice = choice;
          if (!rules.repeatedProstitution && prevChoice == choice) {
            return 0;
          }
        }
      }
    }
    return choice;
  }

  List<int> debugGetNightChoicesList() { // DEBUG FUNCTION
    List<int> choices = List<int>.filled(playerAmount, 0);
    for (Player player in players) {
      if (player.alive) {
        stdout.write("Player #${player.number} (${player.role}) choice: ");
        if (player.role == Role.citizen || player.role == Role.jester) {
          stdout.writeln("Doesn't choose");
          continue;
        }
        if (player.role == Role.sheriff) {
          stdout.write("Enter 0 if checking option is used: ");
        }
        int input = int.parse(stdin.readLineSync()!);
        input = (input >= 0) && (input <= playerAmount) ? input : 0;
        choices[player.number - 1] = input;
      }
    }
    return choices; 
  }

  void getNightChoices(List<int> choices){
    for (int index = 0; index < playerAmount; index++) { // choices.length == playerAmount assumed true
      players[index].choice = choices[index];
    }
  }

  void processNightTargets() {
    phaseVictims.clear();
    int mafiaTarget = getFinalMafiaTarget();
    int murdererTarget = getFinalRoleTarget(Role.murderer);
    int sheriffTarget = getFinalRoleTarget(Role.sheriff);
    int doctorTarget = getFinalRoleTarget(Role.doctor);
    int prostituteTarget = getFinalRoleTarget(Role.prostitute);
    checkTarget(mafiaTarget, doctorTarget, prostituteTarget);
    checkTarget(murdererTarget, doctorTarget, prostituteTarget);
    checkTarget(sheriffTarget, doctorTarget, prostituteTarget);
    visitedByProstitute = 0;
    if (prostituteTarget != 0) {
      if (players[prostituteTarget - 1].alive) {
        visitedByProstitute = prostituteTarget;
      }
    }
    eraseChoices();
  }

  void killPlayer(int target) {
    if (target != 0) { // excessive
      if (players[target - 1].alive) {
        players[target - 1].alive = false;
        curPlayerAmount--;
        if (players[target - 1].role == Role.mafia || players[target - 1].role == Role.godfather) {
          curMafiaAmount--;
        }
        phaseVictims.add(target);
      }
    }
  }

  void checkTarget(int target, int doctorTarget, int prostituteTarget) {
    if (target != 0) {
      if (target != doctorTarget) {
        if (rules.specialMechanics) {
          if (players[target - 1].role == Role.prostitute) {
            killPlayer(target);
            if (prostituteTarget != doctorTarget) {
              killPlayer(prostituteTarget);
            }
          }
        } else {
          killPlayer(target);
        }
      } else if (rules.specialMechanics && players[target - 1].role == Role.prostitute) {
        killPlayer(prostituteTarget);
      }
    }
  }
  
  void debugNightAnnouncement() { // DEBUG FUNCTION
    if (phaseVictims.isEmpty) {
      stdout.writeln("No one has been killed!");
    }
    for (int number in phaseVictims) {
      stdout.writeln("Player #$number has been killed");
    }
    if (visitedByProstitute != 0) {
      stdout.writeln("Player #$visitedByProstitute has been visited by prostitute");
    }
  } 


  // TODO: Infinite loop is possible & don't forget about this function
  void updateCycleCounter() {
    do {
      discussionStartsFrom = discussionStartsFrom % playerAmount + 1;
    } while (!players[discussionStartsFrom - 1].alive);
  }
  
  List<int> debugGetSuggestionsList() { // DEBUG FUNCTION
    List<int> suggestions = List<int>.filled(playerAmount, 0);
    for (int number = discussionStartsFrom; number < discussionStartsFrom + playerAmount; number++) {
      int index = (number - 1) % playerAmount;
      if (players[index].alive) {
        stdout.write("Player #${players[index].number} suggestion for voting: ");
        int input = int.parse(stdin.readLineSync()!);
        input = (input >= 0) && (input <= playerAmount) ? input : 0;
        suggestions[index] = input;
      }
    }
    return suggestions;
  }

  void getSuggestions(List<int> suggestions) {
    for (int index = 0; index < playerAmount; index++) { // suggestions.length == playerAmount assumed ture
      players[index].choice = suggestions[index];
    }
    getFinalSuggestionsList();
  }
  
  void getFinalSuggestionsList() {
    phaseVictims.clear();
    for (int number = discussionStartsFrom; number < discussionStartsFrom + playerAmount; number++) {
      int index = (number - 1) % playerAmount;
      int choice = players[index].choice;
      if (players[index].alive && choice != 0) {
        if (players[choice - 1].alive && !phaseVictims.contains(choice)) {
            phaseVictims.add(choice);
        }
      }
    }
    eraseChoices();
  }

  List<int> debugGetVotesList(bool isRevoting, bool lastRevoting) { // DEBUG FUNCTION
    List<int> votes = List<int>.filled(playerAmount, 0);
    if (phaseVictims.isEmpty) {
      stdout.writeln("No one has been suggested");
      return votes;
    }
    if (isRevoting && !lastRevoting) {
      stdout.writeln("Revoting!");
    }
    if (!lastRevoting)
    {
      stdout.write("Voting for players in this order: ");
      for (int index = 0; index < phaseVictims.length; index++) {
        stdout.write("#${phaseVictims[index]}");
        stdout.write(index != phaseVictims.length - 1 ? ", " : "\n");
      }
      if (rules.skipOption) {
        stdout.writeln("Enter 0 to vote for skip");
      }
    }
    if (lastRevoting)
    {
        stdout.writeln("Last revoring!");
        stdout.writeln("Enter 0 to vote for skip");
        stdout.writeln("Enter 1 to execute all");
    }
    for (Player player in players) {
      if (player.alive) {
        stdout.write("Player #${player.number} vote: ");
        int input = int.parse(stdin.readLineSync()!);
        input = (input >= 0) && (input <= playerAmount) ? input : 0;
        votes[player.number - 1] = input;
      }
    }
    return votes;
  }

  void getVotes(List<int> votes) {
    for (int index = 0; index < playerAmount; index++) { // votes.length == playerAmount assumed ture
      players[index].choice = votes[index];
    }
  }

  void processVoting(bool isRevoting) {
    int lastOption = 0;
    List<int> votes = List<int>.filled(phaseVictims.length, 0);
    if (phaseVictims.isEmpty) {
      eraseChoices(); 
      return;
    } 
    for (Player player in players) {
      if (player.alive && !(rules.voteDeprivation && player.number == visitedByProstitute)) {
        int index = phaseVictims.indexOf(player.choice);
        if (index != -1) {
          votes[index]++;
        } else {
          lastOption++;
        }
      }
    }
    eraseChoices();
    if (!rules.skipOption) {
      votes[votes.length - 1] += lastOption;
      lastOption = 0;
    }
    int maxVotes = 0;
    for (int index = 0; index < votes.length; index++) {
      if (votes[index] > maxVotes) {
        maxVotes = votes[index];
      } 
    }
    if (rules.skipOption && lastOption >= maxVotes) {
      phaseVictims.clear();
      return;
    }
    if (!isRevoting) {
      List<int> victims = List<int>.empty(growable: true);
      for (int index = 0; index < votes.length; index++) {
        if (votes[index] == maxVotes) {
          victims.add(phaseVictims[index]);
        }
      }
      phaseVictims = victims;
    } else {
      if (votes.indexOf(maxVotes) == votes.lastIndexOf(maxVotes)) {
        int victim = phaseVictims[votes.indexOf(maxVotes)];
        phaseVictims.clear();
        phaseVictims.add(victim);
      }
    }
  }

  void processLastRevoting() {
    int spare = 0;
    int execute = 0;
    for (Player player in players) {
      if (player.alive && !(rules.voteDeprivation && player.number == visitedByProstitute)) {
        if (player.choice == 1) {
          execute++;
        } else {
          spare++;
        }
      }
    }
    eraseChoices();
    if (spare >= execute) {
      phaseVictims.clear();
    }
  }
  
  int getVotingResults() {
    if (phaseVictims.isEmpty) {
      return 0;
    }
    if (phaseVictims.length == 1) {
      return phaseVictims[0];
    }
    return -1;
  }
  
  void executeVictims() {
    List<int> dayVictims = phaseVictims;
    for (int cntr = 0; cntr < dayVictims.length; cntr++) {
      int number = dayVictims[cntr];
      if (number != 0) {
        killPlayer(number);
        phaseVictims.removeLast();
      }
    }
  }

  void debugDayAnnouncement() { // DEBUG FUNCTION
    for (int number in phaseVictims) {
      stdout.writeln("Player #$number has been executed");
    }
  } 

  // TODO:
  Role isGameOver() {
    return Role.none;
  } 
  
  void debugPrint() {
    stdout.writeln("Player amount = $playerAmount");
    stdout.writeln("Current player amount = $curPlayerAmount");
    stdout.writeln("Mafia amount = $mafiaAmount");
    stdout.writeln("Current mafia amount = $curMafiaAmount");
    for (Player player in players) {
      player.debugPrint();
    }
  }
}

class Rules {
  int playerAmount          = 0;
  int mafiaAmount           = 0;
  bool godfather            = false;
  bool sheriff              = false;
  bool doctor               = false;
  bool prostitute           = false;
  bool murderer             = false;
  bool jester               = false;
  // int personalSpeechTime    = 0;
  // int commonDiscussionTime  = 0;
  // int lastWordsTime         = 0;
  // int nightActionTime       = 0;
  // int votingTime            = 0;
  bool skipOption           = false;
  // bool blindShooting        = false;
  bool unanimousKilling     = false;
  bool selfHealing          = false;
  bool selfHealingLimited   = false;  
  int selfHealingLimit      = 0;
  bool repeatedHealing      = false;
  bool repeatedProstitution = false;
  // bool speechDeprivation    = false;
  bool voteDeprivation      = false; 
  bool specialMechanics     = false;
  bool murdererCheckable    = false;
  bool jesterSoleVictory    = false;

  Rules();

  void setDebugConfig(int option) {
    switch (option) {
      default:
        playerAmount = 10;
        mafiaAmount = 3;
        godfather = sheriff = doctor = prostitute = murderer = jester = true;
    }
  }
}
