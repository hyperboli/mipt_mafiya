import "package:flutter/material.dart";
import "package:mafiya/future/logic.dart";

void main() => runApp(MafiaApp());

class MafiaApp extends StatefulWidget {
  @override 
  State<StatefulWidget> createState() => MafiaAppState();
}

class MafiaAppState extends State<MafiaApp> {
  Rules rules = Rules();
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Mafia Offline",
      home: Scaffold (

        appBar: AppBar(
          title: const Text("Mafia Offline"), 
          backgroundColor: Colors.red
        ),

        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children:[

                Container(height: 40),
                const Text("Game parameters", style: TextStyle(fontSize: 30)),
                Container(height: 20),

                Row( // buttons
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.red),
                        onPressed: (){},
                        child: Text("Start\ngame", style: TextStyle(fontSize: 15)),
                      ),
                    ),
                    Container(width:50),
                    Container(
                      width: 100,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.red),
                        onPressed: (){},
                        child: Text("Find\ngame", style: TextStyle(fontSize: 15)),
                      ),
                    )
                  ]
                ),
                
                Container( // player amount
                  width: 300,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Player amount: ${rules.playerAmount}",
                      labelStyle: const TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    keyboardType: TextInputType.number,
                    onSubmitted: (String? input) {
                      int value = int.parse(input!);
                      setState(() {
                        rules.playerAmount = value;
                      });
                    },
                  )
                ),

                Container( // mafia amount
                  width: 300,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Mafia amount: ${rules.mafiaAmount}",
                      labelStyle: const TextStyle(fontSize: 20, color: Colors.black)
                    ),
                    keyboardType: TextInputType.number,
                    onSubmitted: (String? input) {
                      int value = int.parse(input!);
                      setState(() {
                        rules.mafiaAmount = value;
                      });
                    },
                  )
                ),

                Container( // godfather
                  width: 350,
                  child: CheckboxListTile(
                      title: Text(
                        "Godfather in game:\n${rules.godfather}", 
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 20, color: Colors.black)
                      ),
                      controlAffinity: ListTileControlAffinity.platform,
                      value: rules.godfather,
                      onChanged: (bool? value) {
                        setState(() {
                          rules.godfather = value!;
                        });
                      }
                  ),
                ),
                Container(
                  width: 300,
                  child: const Text(
                    "Godfather is the head of mafia who can check if a player is the sheriff",
                    style: TextStyle(fontSize: 15, color: Colors.grey)
                  ),
                ),
                  
                Container( // sheriff
                  width: 350,
                  child: CheckboxListTile(
                      title: Text(
                        "Sheriff in game:\n${rules.sheriff}", 
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 20, color: Colors.black)
                      ),
                      controlAffinity: ListTileControlAffinity.platform,
                      value: rules.sheriff,
                      onChanged: (bool? value) {
                        setState(() {
                          rules.sheriff = value!;
                        });
                      }
                  ),
                ),
                Container(
                  width: 300,
                  child: const Text(
                    "Sheriff is capable of checking whether a player is mafia or murderer",
                    style: TextStyle(fontSize: 15, color: Colors.grey)
                  ),
                ),

                Container( // doctor
                  width: 350,
                  child: CheckboxListTile(
                      title: Text(
                        "Doctor in game:\n${rules.doctor}", 
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 20, color: Colors.black)
                      ),
                      controlAffinity: ListTileControlAffinity.platform,
                      value: rules.doctor,
                      onChanged: (bool? value) {
                        setState(() {
                          rules.doctor = value!;
                        });
                      }
                  ),
                ),
                Container(
                  width: 300,
                  child: const Text(
                    "Doctor has ability of healing people",
                    style: TextStyle(fontSize: 15, color: Colors.grey)
                  ),
                ),

                Container( // prostitute
                  width: 350,
                  child: CheckboxListTile(
                      title: Text(
                        "Prostitute in game:\n${rules.prostitute}", 
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 20, color: Colors.black)
                      ),
                      controlAffinity: ListTileControlAffinity.platform,
                      value: rules.prostitute,
                      onChanged: (bool? value) {
                        setState(() {
                          rules.prostitute = value!;
                        });
                      }
                  ),
                ),
                Container(
                  width: 300,
                  child: const Text(
                    "One visited by prostitute during the night will become more useless during the day",
                    style: TextStyle(fontSize: 15, color: Colors.grey)
                  ),
                ),

                Container( // murderer
                  width: 350,
                  child: CheckboxListTile(
                      title: Text(
                        "Murderer in game:\n${rules.murderer}", 
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 20, color: Colors.black)
                      ),
                      controlAffinity: ListTileControlAffinity.platform,
                      value: rules.murderer,
                      onChanged: (bool? value) {
                        setState(() {
                          rules.murderer = value!;
                        });
                      }
                  ),
                ),
                Container(
                  width: 300,
                  child: const Text(
                    "The goal of murdere is to kill everyone, even mafia",
                    style: TextStyle(fontSize: 15, color: Colors.grey)
                  ),
                ),

                Container( // jester
                  width: 350,
                  child: CheckboxListTile(
                      title: Text(
                        "Jester in game:\n${rules.jester}", 
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 20, color: Colors.black)
                      ),
                      controlAffinity: ListTileControlAffinity.platform,
                      value: rules.jester,
                      onChanged: (bool? value) {
                        setState(() {
                          rules.jester = value!;
                        });
                      }
                  ),
                ),
                Container(
                  width: 300,
                  child: const Text(
                    "The jester wins only by being executed during the day",
                    style: TextStyle(fontSize: 15, color: Colors.grey)
                  ),
                ),

                Container( // skip option
                  width: 350,
                  child: CheckboxListTile(
                      title: Text(
                        "Skip option:\n${rules.skipOption}", 
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 20, color: Colors.black)
                      ),
                      controlAffinity: ListTileControlAffinity.platform,
                      value: rules.skipOption,
                      onChanged: (bool? value) {
                        setState(() {
                          rules.skipOption = value!;
                        });
                      }
                  ),
                ),
                Container(
                  width: 300,
                  child: const Text(
                    "Option to execute no one during the day",
                    style: TextStyle(fontSize: 15, color: Colors.grey)
                  ),
                ),

                Container( // unanimous killing
                  width: 350,
                  child: CheckboxListTile(
                      title: Text(
                        "Mafia kills unanimously:\n${rules.unanimousKilling}", 
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 20, color: Colors.black)
                      ),
                      controlAffinity: ListTileControlAffinity.platform,
                      value: rules.unanimousKilling,
                      onChanged: (bool? value) {
                        setState(() {
                          rules.unanimousKilling = value!;
                        });
                      }
                  ),
                ),
                Container(
                  width: 300,
                  child: const Text(
                    "If false, the target will only be killed by the majority",
                    style: TextStyle(fontSize: 15, color: Colors.grey)
                  ),
                ),

                Container( // doctor selfhealing
                  width: 350,
                  child: CheckboxListTile(
                      title: Text(
                        "Doctor selfhealing:\n${rules.selfHealing}", 
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 20, color: Colors.black)
                      ),
                      controlAffinity: ListTileControlAffinity.platform,
                      value: rules.selfHealing,
                      onChanged: (bool? value) {
                        setState(() {
                          rules.selfHealing = value!;
                        });
                      }
                  ),
                ),
                Container( // doctor selfhealing limited
                  width: 350,
                  child: CheckboxListTile(
                      title: Text(
                        "Doctor selfhealing limited:\n${rules.selfHealingLimited}", 
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 20, color: Colors.black)
                      ),
                      controlAffinity: ListTileControlAffinity.platform,
                      value: rules.selfHealingLimited,
                      onChanged: (bool? value) {
                        setState(() {
                          rules.selfHealingLimited = value!;
                        });
                      }
                  ),
                ),
                Container( // doctor selfhealing limit
                width: 300,
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Doctor self healing limit: ${rules.selfHealingLimit}",
                    labelStyle: const TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  keyboardType: TextInputType.number,
                  onSubmitted: (String? input) {
                    int value = int.parse(input!);
                    setState(() {
                      rules.selfHealingLimit = value;
                    });
                  },
                )
              ),

                Container( // repeated healing
                  width: 350,
                  child: CheckboxListTile(
                      title: Text(
                        "Doctor repeated healing:\n${rules.repeatedHealing}", 
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 20, color: Colors.black)
                      ),
                      controlAffinity: ListTileControlAffinity.platform,
                      value: rules.repeatedHealing,
                      onChanged: (bool? value) {
                        setState(() {
                          rules.repeatedHealing = value!;
                        });
                      }
                  ),
                ),
                Container(
                  width: 300,
                  child: const Text(
                    "Doctor can heal the same player several times in a row",
                    style: TextStyle(fontSize: 15, color: Colors.grey)
                  ),
                ),

                Container( // repeated prostitution
                  width: 350,
                  child: CheckboxListTile(
                      title: Text(
                        "Prostitute repeated visiting:\n${rules.repeatedProstitution}", 
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 20, color: Colors.black)
                      ),
                      controlAffinity: ListTileControlAffinity.platform,
                      value: rules.repeatedProstitution,
                      onChanged: (bool? value) {
                        setState(() {
                          rules.repeatedProstitution = value!;
                        });
                      }
                  ),
                ),
                Container(
                  width: 300,
                  child: const Text(
                    "Prostitute can visit the same player several times in a row",
                    style: TextStyle(fontSize: 15, color: Colors.grey)
                  ),
                ),

                Container( // vote deprivation
                  width: 350,
                  child: CheckboxListTile(
                      title: Text(
                        "Prostitute vote deprivation:\n${rules.voteDeprivation}", 
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 20, color: Colors.black)
                      ),
                      controlAffinity: ListTileControlAffinity.platform,
                      value: rules.voteDeprivation,
                      onChanged: (bool? value) {
                        setState(() {
                          rules.voteDeprivation = value!;
                        });
                      }
                  ),
                ),
                Container(
                  width: 300,
                  child: const Text(
                    "Prostitute deprives of voting right",
                    style: TextStyle(fontSize: 15, color: Colors.grey)
                  ),
                ),
                
                Container( // murderer checkable
                  width: 350,
                  child: CheckboxListTile(
                      title: Text(
                        "Sheriff can check murderer:\n${rules.murdererCheckable}", 
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 20, color: Colors.black)
                      ),
                      controlAffinity: ListTileControlAffinity.platform,
                      value: rules.murdererCheckable,
                      onChanged: (bool? value) {
                        setState(() {
                          rules.murdererCheckable = value!;
                        });
                      }
                  ),
                ),
                
                Container( // jester solo victory
                  width: 350,
                  child: CheckboxListTile(
                      title: Text(
                        "Jester wins solo:\n${rules.jesterSoleVictory}", 
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 20, color: Colors.black)
                      ),
                      controlAffinity: ListTileControlAffinity.platform,
                      value: rules.jesterSoleVictory,
                      onChanged: (bool? value) {
                        setState(() {
                          rules.jesterSoleVictory = value!;
                        });
                      }
                  ),
                ),
                
                Container( // special mechanics
                  width: 350,
                  child: CheckboxListTile(
                      title: Text(
                        "Special mechanics:\n${rules.specialMechanics}", 
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 20, color: Colors.black)
                      ),
                      controlAffinity: ListTileControlAffinity.platform,
                      value: rules.specialMechanics,
                      onChanged: (bool? value) {
                        setState(() {
                          rules.specialMechanics = value!;
                        });
                      }
                  ),
                ),
                Container(
                  width: 300,
                  child: const Text(
                    "If prostitute targeted, dies with her visitor, " +
                    "if visitor targeted, doesn't dies:" +
                    "basically, she works at home",
                    style: TextStyle(fontSize: 15, color: Colors.grey)
                  ),
                ),
                
                Container(height: 20),
              ]
            )
          )
        )
      )
    );
  }
}
