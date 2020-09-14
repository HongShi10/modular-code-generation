// Global Variables 
double temperature = 20;

double pre_temperature = 20;

bit thermostat_finished = 0;




proctype clock_pro(){

    INITIAL: (thermostat_finished == 1) ->
        d_step{
            thermostat_finished == 0; 
            // ADD ASSERT STATEMENT CHECK HERE
            //if
            //:: (pre_x < y) -> assert(false)
            //:: else -> skip
            //fi
            pre_temperature = temperature;

            temperature = 20;

    }
}

proctype thermostat_model(){

    t1:  (thermostat_finished == 0) -> 
        
        pre_temperature = 10 - pre_temperature;
        if
        ::(pre_temperature <= 2278) ->  thermostat_finished = 1; goto t2;
        ::(pre_temperature > 2278) -> thermostat_finished == 1; goto t1;
        ::else -> thermostat_finished == 1; goto t1;
        fi;

    t2:  (thermostat_finished == 0) -> 
        
        pre_temperature = 3778 - pre_temperature;
        if
        ::(pre_temperature >= 2500) ->  thermostat_finished = 1; goto t1;
        ::(pre_temperature < 2500) -> thermostat_finished == 1; goto t2;
        ::else -> thermostat_finished == 1; goto t2;
        fi;

}
init {
    atomic {
         run thermostat_model();
         run clock_pro();
}