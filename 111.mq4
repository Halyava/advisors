//+------------------------------------------------------------------+
//|                                                          111.mq4 |
//|                                                               DH |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "DH"
#property link      ""

extern double delta = 0.07;
extern double LotSize = 0.5;
extern double StopLoss = 0.20;
extern double TakeProfit = 0.20;

string key = "111";

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

      Print("bb = " + bb + "; ma21 = " + ma21 + "; delta = " + (bb - ma21) + "; openPos = " + openPos);

      if (MathAbs(bb - ma21) > delta)
      {
         if (bb > ma21)
         {
            for(i=0; i<total; i++)
            {     
               OrderSelect(i, SELECT_BY_POS);
               if (OrderSymbol() == Symbol() && OrderComment() == key)
               {
                  if (OrderType() == OP_BUY)
                  {
                     OrderClose(OrderTicket(), OrderLots(), Bid, 3, Blue);                 
                  }
                  else
                  {
                     openPos = false;
                  }
               }
            }

            Print("SELL: bb = " + bb + "; ma21 = " + ma21 + "; delta = " + (bb - ma21) + "; openPos = " + openPos);
            if (openPos)
            {
               if (OrderSend(Symbol(),OP_SELL,LotSize,Bid,3,0,0,key,0,0, Red) != -1)
               {
                  if (MathAbs(iClose(NULL, 0, 1) - iOpen(NULL, 0, 0)) < 0.20 && MathAbs(bbhigh1 - bbhigh2) > 0.02)
                  {
                     LotSize = MathMax(0.5, (AccountBalance() - (MathFloor(AccountBalance() / 400) * 100)) / 100) * 0.02;
                     OrderSend(Symbol(),OP_BUY,LotSize,Ask,3,Bid - StopLoss, MathMax(bb, Ask + TakeProfit),NULL,0,0, Green);
                  }
               }
            }
         }
         else
         {
            for(i=0; i<total; i++)
            {     
               OrderSelect(i, SELECT_BY_POS);
               if (OrderSymbol() == Symbol() && OrderComment() == key)
               {
                  if (OrderType() == OP_SELL)
                  {
                     OrderClose(OrderTicket(), OrderLots(), Ask, 3, Blue);                 
                  }
                  else
                  {
                     openPos = false;
                  }
               }
            }

            Print("BUY: bb = " + bb + "; ma21 = " + ma21 + "; delta = " + (bb - ma21) + "; openPos = " + openPos);
            if (openPos)
            {
               if (OrderSend(Symbol(),OP_BUY,LotSize,Ask,3,0,0,key,0,0, Green) != -1)
               {
                  if (MathAbs(iClose(NULL, 0, 1) - iOpen(NULL, 0, 0)) < 0.20 && MathAbs(bblow1 - bblow2) > 0.02)
                  {
                     LotSize = MathMax(0.5, (AccountBalance() - (MathFloor(AccountBalance() / 400) * 100)) / 100) * 0.02;
                     OrderSend(Symbol(),OP_SELL,LotSize,Bid,3,Ask + StopLoss,MathMin(bb, Bid - TakeProfit),NULL,0,0, Green);
                  }
               }
            }
         }
      }

/*
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
*/
   }
   LastBarTime = iTime(NULL, 0, 0);
   return(0);
}
//+------------------------------------------------------------------+

/*
Bars in test	7914
Ticks modelled	1839315
Modelling quality	n/a
Mismatched charts errors	698
Initial deposit	20.00
Total net profit	1014.90
Gross profit	4145.86
Gross loss	-3130.96
Profit factor	1.32
Expected payoff	3.77
Absolute drawdown	9.38
Maximal drawdown	406.72 (46.01%)
Relative drawdown	72.56% (150.20)
Total trades	269
Short positions (won %)	135 (47.41%)
Long positions (won %)	134 (55.22%)
Profit trades (% of total)	138 (51.30%)
Loss trades (% of total)	131 (48.70%)
	Largest
profit trade	158.04
loss trade	-151.59
	Average
profit trade	30.04
loss trade	-23.90
	Maximum
consecutive wins (profit in money)	8 (332.04)
consecutive losses (loss in money)	7 (-56.58)
	Maximal
consecutive profit (count of wins)	384.57 (4)
consecutive loss (count of losses)	-212.36 (2)
	Average
consecutive wins	2
consecutive losses	2

*/