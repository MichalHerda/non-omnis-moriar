//+------------------------------------------------------------------+
//|                                               NonOmnisMoriar.mq4 |
//+------------------------------------------------------------------+
#property strict
//*****************************************************************************************************************************************************
#include "Context.mqh"
//*****************************************************************************************************************************************************
input ENUM_TIMEFRAMES LOW_TF  = PERIOD_M5;
input ENUM_TIMEFRAMES MID_TF  = PERIOD_H1;
input ENUM_TIMEFRAMES HIGH_TF = PERIOD_D1;

input int FAST_MA_PERIOD = 50;
input int SLOW_MA_PERIOD = 200;
input double TREND_THRESHOLD = 0.5;

input int SLOPE_PERIOD = 10;
input ENUM_MA_METHOD MA_METHOD = MODE_EMA;
input ENUM_APPLIED_PRICE APPLIED_PRICE = PRICE_CLOSE;

input int ATR_PERIOD = 500;
//*****************************************************************************************************************************************************
struct Strategy {
   string mode;
   datetime lastBarTime;
   
   
   //******************************
   double trendThreshold;
   int slopePeriod;
   int fastMaPeriod;
   int slowMaPeriod;
   ENUM_MA_METHOD maMethod;
   ENUM_APPLIED_PRICE appliedPrice;
   int atrPeriod;   
   //******************************
};
//*****************************************************************************************************************************************************
Context *LOW_CONTEXT;
Context *MID_CONTEXT;
Context *HIGH_CONTEXT;

Strategy LOW_STRATEGY;
Strategy MID_STRATEGY;
Strategy HIGH_STRATEGY;

//*****************************************************************************************************************************************************
int OnInit()
{
   Print("NonOmnisMoriar - 2026.05.15");
   
   LOW_CONTEXT = new Context(Symbol(), LOW_TF, TREND_THRESHOLD, SLOPE_PERIOD, FAST_MA_PERIOD, SLOW_MA_PERIOD, MA_METHOD, APPLIED_PRICE, ATR_PERIOD);
   MID_CONTEXT = new Context(Symbol(), MID_TF, TREND_THRESHOLD, SLOPE_PERIOD, FAST_MA_PERIOD, SLOW_MA_PERIOD, MA_METHOD, APPLIED_PRICE, ATR_PERIOD);
   HIGH_CONTEXT = new Context(Symbol(), HIGH_TF, TREND_THRESHOLD, SLOPE_PERIOD, FAST_MA_PERIOD, SLOW_MA_PERIOD, MA_METHOD, APPLIED_PRICE, ATR_PERIOD);
   
   LOW_STRATEGY.mode = LOW_CONTEXT.CurrentContext();
   MID_STRATEGY.mode = MID_CONTEXT.CurrentContext();
   HIGH_STRATEGY.mode = HIGH_CONTEXT.CurrentContext();
   
   LOW_STRATEGY.lastBarTime  = iTime(Symbol(), LOW_TF, 0);
   MID_STRATEGY.lastBarTime  = iTime(Symbol(), MID_TF, 0);
   HIGH_STRATEGY.lastBarTime = iTime(Symbol(), HIGH_TF, 0);
   
   LOW_STRATEGY.trendThreshold =TREND_THRESHOLD; MID_STRATEGY.trendThreshold =TREND_THRESHOLD; HIGH_STRATEGY.trendThreshold =TREND_THRESHOLD;
   LOW_STRATEGY.slopePeriod = SLOPE_PERIOD; MID_STRATEGY.slopePeriod = SLOPE_PERIOD; HIGH_STRATEGY.slopePeriod = SLOPE_PERIOD;
   LOW_STRATEGY.fastMaPeriod = FAST_MA_PERIOD; MID_STRATEGY.fastMaPeriod = FAST_MA_PERIOD; HIGH_STRATEGY.fastMaPeriod = FAST_MA_PERIOD;
   LOW_STRATEGY.slowMaPeriod = SLOW_MA_PERIOD; MID_STRATEGY.slowMaPeriod = SLOW_MA_PERIOD; HIGH_STRATEGY.slowMaPeriod = SLOW_MA_PERIOD;
   LOW_STRATEGY.maMethod = MA_METHOD; MID_STRATEGY.maMethod = MA_METHOD; HIGH_STRATEGY.maMethod = MA_METHOD;
   LOW_STRATEGY.appliedPrice = APPLIED_PRICE; MID_STRATEGY.appliedPrice = APPLIED_PRICE; HIGH_STRATEGY.appliedPrice = APPLIED_PRICE;
   LOW_STRATEGY.atrPeriod =ATR_PERIOD; MID_STRATEGY.atrPeriod =ATR_PERIOD; HIGH_STRATEGY.atrPeriod =ATR_PERIOD;
     
   EventSetTimer(5);
   
   return(INIT_SUCCEEDED);
}
//*****************************************************************************************************************************************************
void OnDeinit(const int reason)
{
   delete LOW_CONTEXT;
   delete MID_CONTEXT;
   delete HIGH_CONTEXT;
}
//*****************************************************************************************************************************************************
void OnTimer()
{
   if(IsNewBar(Symbol(), LOW_TF)) {
      LOW_STRATEGY.mode = LOW_CONTEXT.CurrentContext();
   }
   if(IsNewBar(Symbol(), MID_TF)) {
      MID_STRATEGY.mode = MID_CONTEXT.CurrentContext();
   }
   if(IsNewBar(Symbol(), HIGH_TF)) {
      HIGH_STRATEGY.mode = HIGH_CONTEXT.CurrentContext();
   }
   
   if     (LOW_STRATEGY.mode == "BULL_UP") {
      Print("BULL_UP");
   }
   else if(LOW_STRATEGY.mode == "BULL_DOWN") {
      Print("BULL_DOWN");
   }
   else if(LOW_STRATEGY.mode == "BULL_RANGE") {
      Print("BULL_RANGE");
   }
   else if(LOW_STRATEGY.mode == "BEAR_UP") {
      Print("BEAR_UP");
   }
   else if(LOW_STRATEGY.mode == "BEAR_DOWN") {
      Print("BEAR_DOWN");
   }
   else if(LOW_STRATEGY.mode == "BEAR_RANGE") {
      Print("BEAR_RANGE");
   }
   else if(LOW_STRATEGY.mode == "UNDEFINED") {
      Print("UNDEFINED");
   }
}
//*****************************************************************************************************************************************************
void OnTick()
{
  
}
//*****************************************************************************************************************************************************
double GetLastLowFractal(string symbol, ENUM_TIMEFRAMES timeframe)
{
   for(int i = 2;i < 100; i++)
   {
      double f = iFractals(symbol, timeframe, MODE_LOWER, i);
      if(f != 0) return f;
   }
   return 0;
}   
//*****************************************************************************************************************************************************
double GetLastHighFractal(string symbol, ENUM_TIMEFRAMES timeframe)
{
   for(int i = 2; i < 100; i++)
   {
      double f = iFractals(symbol, timeframe, MODE_UPPER, i);
      if(f != 0) return f;
   }
   return 0;
}
//*****************************************************************************************************************************************************
bool IsNewBar(string symbol, ENUM_TIMEFRAMES timeframe)
{
   datetime current = iTime(symbol, timeframe, 0);

   if(timeframe == LOW_TF) {
         if(current != LOW_STRATEGY.lastBarTime)
         {
            LOW_STRATEGY.lastBarTime = current;
            return true;
         }
   }
   else if(timeframe == MID_TF) {      
         if(current != MID_STRATEGY.lastBarTime)
         {
            MID_STRATEGY.lastBarTime = current;
            return true;
         }
   }
   else if(timeframe == HIGH_TF) {    
         if(current != HIGH_STRATEGY.lastBarTime)
         {
            HIGH_STRATEGY.lastBarTime = current;
            return true;
         }
   }      
   return false;
}
//*****************************************************************************************************************************************************


