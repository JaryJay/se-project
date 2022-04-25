class Round
{
  String currentWord;
  float timeLimit;
  Player painter;


  Round(String cw, Player p)
  {
    this.currentWord = cw;
    timeLimit = 500; //500 seconds 
    this.painter = p;
  }
  

}
