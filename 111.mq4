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