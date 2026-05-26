# 🏓 Console Pong Game - Assembly Language

A two-player Pong game written in x86 Assembly using Irvine32 library. First to 5 points wins!

## Gamelook 

<img width="574" height="364" alt="image" src="https://github.com/user-attachments/assets/dae69c9a-d7d0-4a3a-84c9-872cd6f9a101" />


## 🎮 Controls

Left Player (P1): W = Up, S = Down

Right Player (P2): Up Arrow = Up, Down Arrow = Down

## 🚀 How to Run

1. Create new MASM project in Visual Studio
2. Add pong.asm to project
3. Build: Ctrl+Shift+B
4. Run: Ctrl+F5

## ⚙️ Customize

Edit constants at top of code:

PADDLE_HEIGHT = 4    (4=medium, 6=easier)

GAME_SPEED = 100     (lower = faster ball)

WIN_SCORE = 5        (points to win)

## 🎯 Game Flow

1. Ball moves automatically
2. Hit ball with paddle to bounce
3. Miss -> opponent gets point
4. First to 5 points wins

## 📋 Workflow

### The game runs in a continuous loop that repeats 10-20 times per second:

Step 1: ProcessInput - Checks if W/S or Arrow keys are pressed, moves paddles

Step 2: ErasePaddle - Removes old paddle positions from screen

Step 3: EraseBall - Removes old ball position from screen

Step 4: UpdateBall - Moves ball by adding direction to X and Y coordinates

Step 5: CheckCollisions - Checks if ball hit walls, paddles, or was missed

         - Hit top/bottom wall -> reverse Y direction
         
         - Hit left/right paddle -> reverse X direction
         
         - Miss paddle -> Add point to other player, reset ball to center
         
Step 6: DrawPaddle - Draws paddles at new positions

Step 7: DrawBall - Draws ball at new position

Step 8: DrawScores - Updates score display at top of screen

Step 9: Delay - Waits 100ms to control game speed

Step 10: Repeat - Jump back to Step 1

This loop continues until a player reaches 5 points, then winner is displayed.

## 🛠️ Troubleshooting

### Irvine32.inc not found: Update include path or use INCLUDE C:\Irvine\Irvine32.inc

### Linker errors: Ensure only one .asm file in project

## Have fun!
