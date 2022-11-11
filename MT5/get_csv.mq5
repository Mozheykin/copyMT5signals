//+------------------------------------------------------------------+
//|                                                      get_csv.mq5 |
//|                                                   Mozheykin Igor |
//|           https://www.upwork.com/freelancers/~01dd7daccf19642309 |
//+------------------------------------------------------------------+
#include <Trade\Trade.mqh>
#property copyright "Mozheykin Igor"
#property link      "https://www.upwork.com/freelancers/~01dd7daccf19642309"
#property version   "1.1"
input string Settings = "=====Settings=====";
input string prefics = "#";
input string sufics = ".pro";
input string Settings_text = "=====Select type: Upper, Lower, NotChange=====";
input string type_text = "NotChange";
input string Setting_lot = "=====Select type: 1:1, fix, %=====";
input string type_lot = "fix";
input double fix_lot = 0.001;
input int procent_lot = 10;
CTrade ExtTrade;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer
   EventSetMillisecondTimer(50);
   //EventSetTimer(1);
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
     {
      Print(SymbolInfoDouble(symbol,SYMBOL_ASK));
      Print(symbol);
      return(ExtTrade.PositionOpen(symbol, ORDER_TYPE_BUY, volume, SymbolInfoDouble(symbol,SYMBOL_ASK), sl, tp, ticket));
     }
   if(type_==1)
     {
      Print(SymbolInfoDouble(symbol,SYMBOL_BID));
      Print(symbol);
      return(ExtTrade.PositionOpen(symbol, ORDER_TYPE_SELL, volume, SymbolInfoDouble(symbol,SYMBOL_BID), sl, tp, ticket));
     }
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
  
  
string ChangeSymbol(string symbol)
{
   if (prefics != "")
            {
            int find_prefics = StringFind(symbol, prefics);
            if ( find_prefics!= -1)
               {
                  StringReplace(symbol, prefics, "");
               }
            }
   if (sufics != "")
            {
            int find_sufics = StringFind(symbol, sufics);
            if ( find_sufics!= -1)
               {
                  StringReplace(symbol, sufics, "");
               }
            }
   if (type_text == "Upper")
      symbol = StringToUpper(symbol);
   if (type_text == "Lower")
      symbol = StringToLower(symbol);
   return symbol;
}
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
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

         symbol = ChangeSymbol(symbol);

         long _digits = SymbolInfoInteger(symbol, SYMBOL_DIGITS);

         if(type_lot == "fix")
            volume = fix_lot;
         if(type_lot == "%")
            volume = (volume * procent_lot) / 100;
         if(volume < SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN))
            volume = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN);
            
         open = NormalizeDouble(open, _digits);
         sl = NormalizeDouble(sl, _digits);
         tp = NormalizeDouble(tp, _digits);
         Print("Line 57: " + account+ "  " + balance+ "  " + symbol+ "  " + volume+ "  " + ticket+ "  " + type_ + "  "+ time+ "  "+ open+ "  "+ sl + "  "+ tp+ "  " + res);
         if(res=="OPEN")
            while(OpenOrder(type_,open,sl,tp,symbol,volume,ticket) == false)
               PrintFormat("OrderSend error %d",GetLastError());
         if(res=="MODIFY")
            Print(OrderModify(type_, open, sl, tp, ticket));
         if(res=="CLOSE")
            Print(OrderClose(type_, ticket));
        }
      //Print("---------------------------------------------------------------------------------------------------------------------------------------------");
      FileClose(filehandle);
      FileDelete("signal.csv");
     }
   

  }
//+------------------------------------------------------------------+
