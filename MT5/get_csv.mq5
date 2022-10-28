//+------------------------------------------------------------------+
//|                                                      get_csv.mq5 |
//|                                                   Mozheykin Igor |
//|           https://www.upwork.com/freelancers/~01dd7daccf19642309 |
//+------------------------------------------------------------------+
#include <Trade\Trade.mqh>
#property copyright "Mozheykin Igor"
#property link      "https://www.upwork.com/freelancers/~01dd7daccf19642309"
#property version   "1.00"

CTrade ExtTrade;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer
   EventSetTimer(1);
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
   EventKillTimer();
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   
  }

bool ChechModifyOrder(double SL, double TP, string comment)
{
   for (int i=0; i<=OrdersTotal(); i++)
      if (OrderGetTicket(i) > 0)
         {
            if (OrderGetString(ORDER_COMMENT) == comment)
               {
                  if ((OrderGetDouble(ORDER_SL) != SL) || (OrderGetDouble(ORDER_TP) != TP))
                     if(!ExtTrade.OrderModify(OrderGetInteger(ORDER_TICKET), OrderGetDouble(ORDER_PRICE_OPEN), SL, TP, ORDER_TIME_GTC, 0))
                        PrintFormat("OrderSend error %d",GetLastError());
                  return(true);
               }
         }
      for (int i=0; i<=PositionsTotal(); i++)
      if (PositionGetTicket(i) > 0)
         {
            if (PositionGetString(POSITION_COMMENT) == comment)
               {      
                  if ((PositionGetDouble(POSITION_SL) != SL) || (PositionGetDouble(POSITION_TP) != TP))
                     if(!ExtTrade.PositionModify(PositionGetInteger(POSITION_TICKET), SL, TP))
                        PrintFormat("OrderSend error %d",GetLastError());
                  return(true);
               }
         }
   return(false);
}
  
bool OpenOrder()
{

return(false);
}
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
      int filehandle = FileOpen("signal.csv", FILE_READ);
      
      if (filehandle != INVALID_HANDLE){
         while (FileIsEnding(filehandle)==false){
            long account = FileReadLong(filehandle);
            double balance = FileReadDouble(filehandle);
            string symbol = FileReadString(filehandle);
            double volume = FileReadDouble(filehandle);
            string ticket = IntegerToString(FileReadLong(filehandle));
            ulong type = FileReadLong(filehandle);
            long time = FileReadLong(filehandle);
            double open = FileReadDouble(filehandle);
            double sl = FileReadDouble(filehandle);
            double tp = FileReadDouble(filehandle);
            
            if (!ChechModifyOrder(sl, tp, ticket))
               OpenOrder();
         }
         FileClose(filehandle);
      }
   
  }
//+------------------------------------------------------------------+
//| Trade function                                                   |
//+------------------------------------------------------------------+


