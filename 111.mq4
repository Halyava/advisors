//+------------------------------------------------------------------+
//|                                                          111.mq4 |
//|                                                               DH |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "DH"
#property link      ""

extern double delta = 0.05;
extern double LotSize = 0.01;

datetime LastBarTime = 0;
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
{
   int i;
   int total=OrdersTotal();
   bool openPos = true;

   if (iTime(NULL, 0, 0) > LastBarTime)
   {
      double bb = iBands(NULL, 0, 20, 2, 0, PRICE_CLOSE, MODE_MAIN, 0);
      double prevbb = iBands(NULL, 0, 20, 2, 0, PRICE_CLOSE, MODE_MAIN, 1);
      double bbhigh1 = iBands(NULL, 0, 20, 2, 0, PRICE_CLOSE, MODE_UPPER, 1);
      double bblow1 = iBands(NULL, 0, 20, 2, 0, PRICE_CLOSE, MODE_LOWER, 1);
      double bbhigh2 = iBands(NULL, 0, 20, 2, 0, PRICE_CLOSE, MODE_UPPER, 2);
      double bblow2 = iBands(NULL, 0, 20, 2, 0, PRICE_CLOSE, MODE_LOWER, 2);
      double ma21 = iMA(NULL, 0, 21, 0, MODE_EMA, PRICE_CLOSE, 0);
      double prevClose = iClose(NULL, 0, 1);
      double profit = 0;

      for(i=0; i<total; i++)
      {
         OrderSelect(i, SELECT_BY_POS);
         if(OrderType() == OP_BUY && OrderOpenPrice() < prevbb)
         {
            OrderModify(OrderTicket(),OrderOpenPrice(),prevbb,OrderTakeProfit(),0,Yellow);
         }
         else if(OrderType() == OP_SELL && OrderOpenPrice() > prevbb)
         {
            OrderModify(OrderTicket(),OrderOpenPrice(),prevbb,OrderTakeProfit(),0,Yellow);
         }
      }

//      Print("bb = " + bb + "; ma21 = " + ma21 + "; bb - ma21 = " + (bb - ma21));

      if ((bb - ma21) > delta)
      {
         for(i=0; i<total; i++)
         {     
            OrderSelect(i, SELECT_BY_POS);
            if (OrderSymbol() == Symbol() && (OrderType() == OP_SELL || (OrderType() == OP_BUY && (prevClose - bb) > delta)))
            {
               openPos = false;
            }
         }
         if (MathAbs(bbhigh1 - bbhigh2) <= 0.01)
         {
            profit = bblow1;
         }

         if (openPos) OrderSend(Symbol(),OP_SELL,LotSize,Bid,3,bbhigh1,0,"",0,0, Red);
      }

      if ((ma21 - bb) > delta)
      {
         for(i=0; i<total; i++)
         {     
            OrderSelect(i, SELECT_BY_POS);
            if (OrderSymbol() == Symbol() && (OrderType() == OP_BUY || (OrderType() == OP_SELL && prevClose < bb)))
            {
               openPos = false;
            }
         }
         if (MathAbs(bblow1 - bblow2) <= 0.01)
         {
            profit = bbhigh1;
         }
         
         if (openPos) OrderSend(Symbol(),OP_BUY,LotSize,Ask,3,bblow1,profit,"",0,0, Green);
      }
   }
   LastBarTime = iTime(NULL, 0, 0);
   return(0);
}
//+------------------------------------------------------------------+

/*
Bars in test	3932
Ticks modelled	1111842
Modelling quality	n/a
Mismatched charts errors	115
Initial deposit	10000.00
Total net profit	26645.12
Gross profit	50934.73
Gross loss	-24289.61
Profit factor	2.10
Expected payoff	176.46
Absolute drawdown	276.02
Maximal drawdown	4888.98 (17.28%)
Relative drawdown	17.28% (4888.98)
Total trades	151
Short positions (won %)	74 (63.51%)
Long positions (won %)	77 (75.32%)
Profit trades (% of total)	105 (69.54%)
Loss trades (% of total)	46 (30.46%)
	Largest
profit trade	2514.94
loss trade	-1518.05
	Average
profit trade	485.09
loss trade	-528.03
	Maximum
consecutive wins (profit in money)	12 (4107.51)
consecutive losses (loss in money)	4 (-1850.41)
	Maximal
consecutive profit (count of wins)	5616.17 (5)
consecutive loss (count of losses)	-1912.90 (2)
	Average
consecutive wins	3
consecutive losses	1

*/