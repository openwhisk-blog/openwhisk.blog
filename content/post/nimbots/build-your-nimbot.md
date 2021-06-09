+++
author = "Michele Sciabarrà"
title = "Nimbots: serverless virtual robots"
date = "2020-12-12"
description = "A tutorial how to build a Nimbot, an OpenWhisk Serverless Action to control a robot."
tags = [ "Tech" ]
hidden = true
+++

[FaasWars](https://nimbots-apigcp.nimbella.io/) is a programming game where you have to write the code that controls a robot  fighting to death with another robot. The robot is a starship that can move in the space and shoot bullets. The goal of the game is to defeat the enemy robot, hitting it 5 times, and of course avoiding the bullets of the enemy.

To control a robot you have to write the control code. The control code  itself is an OpenWhisk serverless action. In the following, there is a tutorial about how to write a progressively smarter control action. 

We are using javascript as the programming language, as it is probably the more widely used and known. You can use however any other programming language available in Nimbella, like Python or Go. All the actions receive their input in JSON format and returns the output in JSON, too. So the logic described here in javascript can be readily translated in any other programming languages.

Let's start now, discussion how to create your robot control code with a step by step tutorial.

## How to control your robot

A serverless action suitable for Nimbots in its simplest form has this format:

```
function main(args) {
    return {"body": []}
}
```

Any Nimbella action returns a map. In our case, we need a web action returning JSON, so you have to use `body` as a mandatory field of your object. The resulting answer has to be an array of maps. In the simplest case it is just an empty array. However if you implement this action way your robot will simply do nothing at all. Just sit down waiting to be hit by the enemy.

You can send commands to the robot. A command is a map, where the keys are the commands given to the robot and the values are the parameters of the command. For example you can order to the robot to "yell" something. If you want your robot displays the current time, you can order it with  `{ "yell": new Date().toLocaleTimeString()}`. Let's put it in an entire action:

```
function main(args) {
    let msg = new Date().toLocaleTimeString()
    return {"body": [{"yell":msg}]}
}
```

If you start the battle, you can see not the robot is telling the current time. As it is not doing anything else, it will not survive for very long if there is a minimally offensive other robot in the battleground.  Indeed, this example is not very useful, battle-wise, but nonetheless we see our robot is doing something, now!

Let's learn how to move around our robot. As we already pointede out, the action returns an array of commands, so you can give multiple orders.

Out first step is to  order to the robot to move forward and then turn to the left, as follows:

```
function main(args) {
    return {"body": [
       {"move_forwards":50},
       {"turn_left":90},
    ]}
}
```

If you run this code you will note the robot will move around, following a square path. Indeed the orders are to move forward 100 pixels and then turn right of 90 degrees, forever. If it is hit, it may change randomly its orientation.

## Reacting to events

If you run the robot this way, is it blind and stupid, but it has not to be this way. Actually, the robot receives informations about its environment in the `args` parameter. The most important value to check is `args.event`.  There are basically 4 events our robot can react to: 

- `idle`: when the robot is running out of commands and has nothing to do
- `enemy-spot`: when the robot sees the enemy right in front of the turret.
- `hit`: when an enemy bullet hits the robot
- `wall-collide`: when the robot hits the wall and cannot move forward any more

Now lets add the ability to shot to the enemy when it sees one. For this purpose we instroduce a swich on the event. Also, we use an array where we push the actions we want to sent. Our revised code is thus:

```
function main(args) {
    let actions = []
    switch(args.event) {
        case "idle":
            actions.push({"move_forwards":50})
            actions.push({"turn_left":90})
            break;
        case "enemy-spot":
            actions.push({"yell": "Fire!"})
            actions.push({"shoot":true})
            break;
    }
    return {"body": actions}
}
```

Now, another detail. We say a command is wrapped in a map, but in a map there has not to be only one command. It can be multiple command at the same time. But those has to be be something the robot can do at the same time.

So for example a robot cannot move at the same time forward and backward, or move and turn. So the following actions are "sequential", in the sense you can put only one at a time in the command maps:

- `move_forwards <number>`: move forward of the given number of pixels
- `move_backwards <number>`: move backwards of the given number of pixels
- `move_opposide <number>`: move in the opposite direction, useful when you hit a wall
- `turn_left <degrees>`: turn the robot to the left of the given degrees
- `turn_right <degrees>`: turn the robot right of the given degrees

However, you can order at the same time to yell and shot, for example. So this is a valid command:  `{"yell": "Fire!", "shoot":true}`. Those are parallel actions.

In addition, you can also move the turret. This is thus the complete list of parallel actions:

- `yell <message>` show a message
- `shot: true`: order to shot, if the value is true
- `turn_turret_left <degrees>`: turn the robot to the left of the given degrees
- `turn_turret_right <degrees>`: turn the robot to the right of the given degrees
- `data: <object>`: store the object and return it in every further event

Now let's put all together, handling also the cases of the robot colliding with the wall or being hit. What it follows is he default control programm that is the default when you create a new robot.

```
function main(args){
    let actions = []
    switch(args.event) {
        case "idle":
            actions.push({"turn_turret_left": 45, "move_forwards": 50})
            actions.push({"turn_left": 45})
            break;
        case "wall-collide":
            actions.push({"move_opposide":10})
            actions.push({"turn_left":90})
            break;
        case "hit":
            actions.push({"yell": "Ooops!"})
            break
        case "enemy-spot":
            actions.push({"yell": "Fire!", "shoot":true})
            break
        default:
            console.log(args)
    }
    return { "body": actions}
}
```

## Keeping a state

So far we developed a pretty dumb robot, that moves around a square and shoot when he sees the enemy. Lets try to make the robot a bit smarter, using also its ability to "remember" the current state and read more informations about the environment.

Before we continue, let's creating this skeleton of an action:


```
function main(args){
    let actions = []
    switch(args.event) {
        // insert here 
        default: 
           break;
    }
    return { "body": actions}
}
```

In the following we only show pieced of code that handle single events, so you have to insert the snippets we are showing in the `// insert here` section. If we are, for example, showing a `case "idle"` you have to replace that case in the code.

## Informations about yourself

The `args` object does not include only the event as information. It actually includes a lot of informations about you and the enemy. Each request has this format:

```
{
  "event": "idle",
  "energy": 5,
  "x": 166,
  "y": 250,
  "angle": 124,
  "tank_angle": 206,
  "turret_angle": 277,
  "enemy_spot": {},
  "data": {}
}
```

So you know your position (`x` and `y`), the angle of the tank (`tank_agle`) and of the turret (`turrent_agle`); also you know the "total" `angle`, that is the sum of the angle of the tank and the turret. Basically, this is the angle of your bullets. 

But that is not all, there are additional informations that are avalable in special cases: when you spot the enemy and you ask to preserve informations. To learn about that, let's learn first how to search for the enemy. The simplest way is to rotate the turret 360 degrees, with this code:

```
case "idle":
   actions.push({"turn_turret_left": 360})
   break;
```

Now, if you start the battle, enable `debug` and click the `Trace` button for a while, so you can intercept the event `enemy-spot`, that will happen at some point while you are rotating when the turret is aligned with the enemy. The `enemy-spot` event looks like this:

```
{
  "event": "enemy-spot",
  "energy": 5,
  "x": 166,
  "y": 250,
  "angle": 348,
  "tank_angle": 195,
  "turret_angle": 152,
  "enemy_spot": {
    "id": 1,
    "x": 368,
    "y": 201,
    "angle": 346,
    "distance": 207,
    "energy": 5
  },
  "data": {}
}
```

## Save and use data

The event in the previous example told you that there is an enemy at a distance  of 207 pixels with angle of 347 degrees. What should we do then? 

We can choose just to shoot, hoping to hit. However it is certanly better if we can remember where we saw the enemy and use this information to align the turret. So let's save the `angle`. We can do this with the `data` command, as follows:

```
 case "enemy-spot":
    actions.push({"data": { "angle": args.enemy_spot.angle} })
    break;
```

Now that robot is preserving some informations,  we can use it  to align our turret to aim to the spotted enemy robot. In general, if our angle is greater than the angle of the enemy we want to move the turret to the left, otherwise to the right, and then shoot when we are aligned with theenemy. 

Once shoot, we want want to forget about the angle we recorded until we see the enemy again.  Also, we want to avoid to be an easy target to let's move when we are idle, and keep rotating the turret to spot the enemy. Putting all together in code, this means:

```
case "idle":
   let data = args.data
   if(data.angle) {
       let me = args.angle
       let it = data.angle
       if(me > it) {
           actions.push({"turn_turret_left": me - it})
       } else {
           actions.push({"turn_turret_right": it - me})
       }
       actions.push({ "shoot": true, "data": {}})
   } else {
        actions.push({"move_forwards": 100, "turn_turret_left": 360})
        actions.push({"turn_left": 30+150*Math.random() })
   }
   break;
```

## Final touches

The robot is now pretty good, but it can be stuck when hits the wall, so we have to react. In our case, we are going to move in the opposite direction and then turning right of 90 degrees.  

```
case "wall-collide":
    actions.push({"move_opposide":10})
    actions.push({"turn_left":90})
    break;
```

Also, when we are hit, better to move away to avoid multiple bullets. Our choice is hence to move backwards of a random amount, to get ourself to safety, away of the enemy fire.

```
case "hit":
    actions.push({"move_backwards": 10+90*Math.random()})
    break;
```

## Conclusion

We have just explored the surface. Now you know the basics, how to move, spot enemy, keep a state and aim. But is this enough? Can you devise more sophisticated strategies? Can you take in account the distance and the velocity of the enemy? Can you anticipate its moves? Can you think of better ways to move away from the bullets? As you can see the possibilities are endless and you are welcome to write the smartest and strongest robot around. And win our FAAS Wars competition. 
