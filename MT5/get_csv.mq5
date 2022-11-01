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
   int filehandle = FileOpen("signal.csv", FILE_READ | FILE_CSV | FILE_ANSI, ";");

   if(filehandle != INVALID_HANDLE)
     {
      while(!FileIsEnding(filehandle))
        {
         long account = long(FileReadString(filehandle));
         double balance = double(FileReadString(filehandle));
         string symbol = FileReadString(filehandle);
         double volume = double(FileReadString(filehandle));
         string ticket = FileReadString(filehandle);
         ulong type_ = ulong(FileReadString(filehandle));
         long time = long(FileReadString(filehandle));
         double open = double(FileReadString(filehandle));
         double sl = double(FileReadString(filehandle));
         double tp = double(FileReadString(filehandle));
         string res = FileReadString(filehandle);


         Print("Line 57: " + account+ "  " + balance+ "  " + symbol+ "  " + volume+ "  " + ticket+ "  " + type_ + "  "+ time+ "  "+ open+ "  "+ sl + "  "+ tp+ "  " + res);
         if(res=="OPEN")
            OpenOrder(type_,open,sl,tp,symbol,volume,ticket);
         if(res=="MODIFY")
            OrderModify(type_, open, sl, tp, ticket);
         if(res=="CLOSE")
            OrderClose(type_, ticket);
         //if (!ChechModifyOrder(sl, tp, ticket))
         //   OpenOrder();
        }
      Print("---------------------------------------------------------------------------------------------------------------------------------------------");
      FileClose(filehandle);
     }
    FileDelete("signal.csv");


  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool ChechModifyOrder(double SL, double TP, string comment)
  {
   for(int i=0; i<=OrdersTotal(); i++)
      if(OrderGetTicket(i) > 0)
        {
         if(OrderGetString(ORDER_COMMENT) == comment)
           {
            if((OrderGetDouble(ORDER_SL) != SL) || (OrderGetDouble(ORDER_TP) != TP))
               if(!ExtTrade.OrderModify(OrderGetInteger(ORDER_TICKET), OrderGetDouble(ORDER_PRICE_OPEN), SL, TP, ORDER_TIME_GTC, 0))
                  PrintFormat("OrderSend error %d",GetLastError());
            return(true);
           }
        }
   for(int i=0; i<=PositionsTotal(); i++)
      if(PositionGetTicket(i) > 0)
        {
         if(PositionGetString(POSITION_COMMENT) == comment)
           {
            if((PositionGetDouble(POSITION_SL) != SL) || (PositionGetDouble(POSITION_TP) != TP))
               if(!ExtTrade.PositionModify(PositionGetInteger(POSITION_TICKET), SL, TP))
                  PrintFormat("OrderSend error %d",GetLastError());
            return(true);
           }
        }
   return(false);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool OrderModify(ulong type_, double open, double sl, double tp, string comment)
  {
   if((type_==0) || (type_==1))
      for(int i=0; i<=PositionsTotal(); i++)
         if(PositionGetTicket(i) > 0)
            if(PositionGetString(POSITION_COMMENT) == comment)
               return(ExtTrade.PositionModify(PositionGetTicket(i), sl, tp));
   if((type_==2) || (type_==3) || (type_==4) || (type_==5))
      for(int i=0; i<=OrdersTotal(); i++)
         if(OrderGetTicket(i) > 0)
            if(OrderGetString(ORDER_COMMENT) == comment)
               return(ExtTrade.OrderModify(OrderGetTicket(i), open, sl, tp, ORDER_TIME_GTC, 0));
   return(false);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool OrderClose(ulong type_, string comment)
  {
   if((type_==0) || (type_==1))
      for(int i=0; i<=PositionsTotal(); i++)
         if(PositionGetTicket(i) > 0)
            if(PositionGetString(POSITION_COMMENT) == comment)
            return(ExtTrade.PositionClose(PositionGetTicket(i)));
   if((type_==2) || (type_==3) || (type_==4) || (type_==5))
      for(int i=0; i<=OrdersTotal(); i++)
         if(OrderGetTicket(i) > 0)
            if(OrderGetString(ORDER_COMMENT) == comment)
               return(ExtTrade.OrderDelete(OrderGetTicket(i)));
   return(false);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool OpenOrder(ulong type_, double open, double sl, double tp, string symbol, double volume, string ticket)
  {
   if(type_ == 0)
      return(ExtTrade.PositionOpen(symbol, ORDER_TYPE_BUY, volume, SymbolInfoDouble(symbol,SYMBOL_ASK), sl, tp, ticket));
   if(type_==1)
      return(ExtTrade.PositionOpen(symbol, ORDER_TYPE_SELL, volume, SymbolInfoDouble(symbol,SYMBOL_BID), sl, tp, ticket));
   if(type_==2)
      return(ExtTrade.OrderOpen(symbol, ORDER_TYPE_BUY_LIMIT, volume, SymbolInfoDouble(symbol,SYMBOL_ASK), open, sl, tp, ORDER_TIME_GTC, 0, ticket));
   if(type_==3)
      return(ExtTrade.OrderOpen(symbol, ORDER_TYPE_SELL_LIMIT, volume, SymbolInfoDouble(symbol,SYMBOL_BID), open, sl, tp, ORDER_TIME_GTC, 0, ticket));
   if(type_==4)
      return(ExtTrade.OrderOpen(symbol, ORDER_TYPE_BUY_STOP, volume, SymbolInfoDouble(symbol,SYMBOL_ASK), open, sl, tp, ORDER_TIME_GTC, 0, ticket));
   if(type_==5)
      return(ExtTrade.OrderOpen(symbol, ORDER_TYPE_SELL_STOP, volume, SymbolInfoDouble(symbol,SYMBOL_BID), open, sl, tp, ORDER_TIME_GTC, 0, ticket));
   return(false);
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {

  }
//+------------------------------------------------------------------+
//| Trade function                                                   |
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
