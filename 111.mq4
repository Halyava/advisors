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
      double prevbbhigh = iBands(NULL, 0, 20, 2, 0, PRICE_CLOSE, MODE_UPPER, 1);
      double prevbblow = iBands(NULL, 0, 20, 2, 0, PRICE_CLOSE, MODE_LOWER, 1);
      double ma21 = iMA(NULL, 0, 21, 0, MODE_EMA, PRICE_CLOSE, 0);
      double prevClose = iClose(NULL, 0, 1);

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
         if (openPos) OrderSend(Symbol(),OP_SELL,LotSize,Bid,3,prevbbhigh,0,"",0,0, Red);
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
         if (openPos) OrderSend(Symbol(),OP_BUY,LotSize,Ask,3,prevbblow,0,"",0,0, Green);
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
Total net profit	24867.02
Gross profit	48888.04
Gross loss	-24021.02
Profit factor	2.04
Expected payoff	173.90
Absolute drawdown	276.02
Maximal drawdown	4978.41 (17.47%)
Relative drawdown	17.47% (4978.41)
Total trades	143
Short positions (won %)	74 (63.51%)
Long positions (won %)	69 (73.91%)
Profit trades (% of total)	98 (68.53%)
Loss trades (% of total)	45 (31.47%)
	Largest
profit trade	2514.94
loss trade	-1518.05
	Average
profit trade	498.86
loss trade	-533.80
	Maximum
consecutive wins (profit in money)	11 (4337.72)
consecutive losses (loss in money)	4 (-1850.41)
	Maximal
consecutive profit (count of wins)	5309.67 (3)
consecutive loss (count of losses)	-1912.90 (2)
	Average
consecutive wins	3
consecutive losses	1

*/