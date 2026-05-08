//+------------------------------------------------------------------+
//|                                               NonOmnisMoriar.mq4 |
//+------------------------------------------------------------------+
#property strict
//*****************************************************************************************************************************************************
#include "Context.mqh"
//*****************************************************************************************************************************************************
input ENUM_TIMEFRAMES lowTF  = PERIOD_M5;
input ENUM_TIMEFRAMES midTF  = PERIOD_H1;
input ENUM_TIMEFRAMES highTF = PERIOD_D1;
input int fastMaPeriod = 50;
input int slowMaPeriod = 200;
//*****************************************************************************************************************************************************
Context *_lowContext;
Context *_midContext;
Context *_highContext;
datetime _lastLowTFBar;
datetime _lastMidTFBar;   
datetime _lastHighTFBar;
//*****************************************************************************************************************************************************
int OnInit()
{
   Print("NonOmnisMoriar - 2026.05.08");
   _lastLowTFBar  = iTime(Symbol(), lowTF, 0);
   _lastMidTFBar  = iTime(Symbol(), midTF, 0);
   _lastHighTFBar = iTime(Symbol(), highTF, 0);
   
   _lowContext = new Context(Symbol(), lowTF);
   _midContext = new Context(Symbol(), midTF);
   _highContext = new Context(Symbol(), highTF);
   
   EventSetTimer(1);
   
   return(INIT_SUCCEEDED);
}
//*****************************************************************************************************************************************************
void OnDeinit(const int reason)
{
   delete _lowContext;
   delete _midContext;
   delete _highContext;
}
//*****************************************************************************************************************************************************
void OnTimer()
{
   if(IsNewBar(Symbol(), lowTF)) {
      Print(EnumToString(lowTF), ", bullish bias: ", _lowContext.BullishBias(), ", fast ma slope: ", _lowContext.FastMaSlope(), ", slow ma slope: ", _lowContext.SlowMaSlope());
   }
   if(IsNewBar(Symbol(), midTF)) {
      Print(EnumToString(midTF), ", bullish bias: ", _midContext.BullishBias(), ", fast ma slope: ", _midContext.FastMaSlope(), ", slow ma slope: ", _midContext.SlowMaSlope());
   }
   if(IsNewBar(Symbol(), highTF)) {
      Print(EnumToString(highTF), ", bullish bias: ", _highContext.BullishBias(), ", fast ma slope: ", _highContext.FastMaSlope(), ", slow ma slope: ", _highContext.SlowMaSlope());
   }
}
//*****************************************************************************************************************************************************
void OnTick()
{
  
}
//*****************************************************************************************************************************************************


bool IsNewBar(string symbol, ENUM_TIMEFRAMES timeframe)
{
   datetime current = iTime(symbol, timeframe, 0);

   if(timeframe == lowTF) {
         if(current != _lastLowTFBar)
         {
            _lastLowTFBar = current;
            return true;
         }
   }
   else if(timeframe == midTF) {      
         if(current != _lastMidTFBar)
         {
            _lastMidTFBar = current;
            return true;
         }
   }
   else if(timeframe == highTF) {    
         if(current != _lastHighTFBar)
         {
            _lastHighTFBar = current;
            return true;
         }
   }      
   return false;
}

