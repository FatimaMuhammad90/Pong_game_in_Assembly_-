🏓 Console Pong Game - Assembly Language

A two-player Pong game written in x86 Assembly using Irvine32 library. First to 5 points wins!
<img width="571" height="356" alt="image" src="https://github.com/user-attachments/assets/583b6fae-3ae7-478d-910a-37dcf5dcb59c" />

🎮 Controls

Left Player (P1): W = Up, S = Down
Right Player (P2): Up Arrow = Up, Down Arrow = Down

🚀 How to Run

1. Create new MASM project in Visual Studio
2. Add pong.asm to project
3. Build: Ctrl+Shift+B
4. Run: Ctrl+F5

⚙️ Customize

Edit constants at top of code:

PADDLE_HEIGHT = 4    (4=medium, 6=easier)
GAME_SPEED = 100     (lower = faster ball)
WIN_SCORE = 5        (points to win)

🎯 Game Flow

1. Ball moves automatically
2. Hit ball with paddle to bounce
3. Miss -> opponent gets point
4. First to 5 points wins

🛠️ Troubleshooting

Irvine32.inc not found: Update include path or use INCLUDE C:\Irvine\Irvine32.inc
Linker errors: Ensure only one .asm file in project
Arrow keys not working: Code checks multiple scan codes

👤 Author

Fatima Muhammad Ali - SP24-BCS-030
CSC321 - Microprocessor and Assembly Language

🎉 Have fun!
