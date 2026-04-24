
# Connect-4: Project Porposal

---

## Idea:

The game is about a 6 rows x 7 coloumns matrix.

There are two players playing against each other -each with a unique color-.

Every player must make one move only in his turn.

In one move the player can choose a coloumn where he can drop his disc.

The first player to make any of the following wins the game:

- makes 4 discs in row vertically
- makes 4 discs in row horizontally
- makes 4 discs in a row diagonally

If the grid is full without anyone winning then it's a tie

![](/pic.jpg)

---
## PEAS:

### Performance:
- Optimization: Does the agent make the optimal move or not?
- Speed: How much time does the agent spend thinking?
- Mistakes: How many mistakes does the agent make in one game?

### Environment: 
- The matrix
- The discs -what are the colors of the discs for both players-
- The current turn -who can make the move-

### Acuator:
- In his turn he can chose a column to put into 

### Sensor:
- A matrix representing the board

---
## ODESA: 

### Observability: 
Fully Observable

### Determinisity: 
Strategic

### Episodic:
Sequential 

### Static:
Semi-dynamic

### Agent:
Multi-agent (Competitive) 

---
## Type 

*The agent is goal based*
We use the minimax algorithm to find out the best way to achieve goal