//+------------------------------------------------------------------+
//|                                                   create_csv.mq5 |
//+------------------------------------------------------------------+
#property version   "1.00"
int orders_count;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer
   EventSetTimer(60);
   orders_count = OrdersTotal();
   Comment("");
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
  
void writer_limits(ulong ticket, int filehandle)
{
   string symbol = OrderGetString(ORDER_SYMBOL);
   double volume = OrderGetDouble(ORDER_VOLUME_INITIAL);
   long account = AccountInfoInteger(ACCOUNT_LOGIN);
   double balance = AccountInfoDouble(ACCOUNT_BALANCE);
   long type = OrderGetInteger(ORDER_TYPE);
   double open = OrderGetDouble(ORDER_PRICE_OPEN);
   double sl = OrderGetDouble(ORDER_SL);
   double tp = OrderGetDouble(ORDER_TP);
   long time = OrderGetInteger(ORDER_TIME_SETUP_MSC);

   FileWrite(filehandle, account, balance, symbol, volume, ticket, type, time, open, sl, tp);
}

void writer(ulong ticket, int filehandle)
{
   string symbol = PositionGetString(POSITION_SYMBOL);
   double volume = PositionGetDouble(POSITION_VOLUME);
   long account = AccountInfoInteger(ACCOUNT_LOGIN);
   double balance = AccountInfoDouble(ACCOUNT_BALANCE);
   long type = PositionGetInteger(POSITION_TYPE);
   double open = PositionGetDouble(POSITION_PRICE_OPEN);
   double sl = PositionGetDouble(POSITION_SL);
   double tp = PositionGetDouble(POSITION_TP);
   long time = PositionGetInteger(POSITION_TIME_MSC);

   FileWrite(filehandle, account, balance, symbol, volume, ticket, type, time, open, sl, tp);
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   int filehandle = FileOpen("signal.csv", FILE_WRITE|FILE_CSV);
   if(filehandle!=INVALID_HANDLE)
     {
      for(int i=0; i<OrdersTotal(); i++)
        {
         ulong ticket = OrderGetTicket(i);
         if(ticket >= 0) writer_limits(ticket, filehandle);
        }
      for (int i=0; i<PositionsTotal(); i++)
         {
            ulong ticket = PositionGetTicket(i);
            if (ticket>= 0) writer(ticket, filehandle);
         }
      FileClose(filehandle);
     }
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//if (ticket_end_file)



  }
//+------------------------------------------------------------------+
