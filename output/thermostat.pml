int global_tick = 0
// Global Variables 
int temperature = 200000000;

int pre_temperature = 200000000;

bit thermostat_finished = 0;




proctype clock_pro(){

    INITIAL:
        if
        ::(global_tick == 1000000) -> skip;
        ::(thermostat_finished == 1) ->
            d_step{
                global_tick++
                thermostat_finished = 0; 
                // ADD ASSERT STATEMENT CHECK HERE
                //if
                //:: (pre_x < y) -> assert(false)
                //:: else -> skip
                //fi
                pre_temperature = temperature;
            }
        goto INITIAL;
        fi;
}

proctype thermostat_model(){

    t1:  (thermostat_finished == 0) -> 
        if
        ::(pre_temperature <= 227800000) ->  thermostat_finished = 1; goto t2;
        ::(pre_temperature > 227800000) -> temperature = (100000000 - pre_temperature) * 1000 / 10000000 + pre_temperature; thermostat_finished = 1; goto t1
        fi;

    t2:  (thermostat_finished == 0) -> 
        if
        ::(pre_temperature >= 250000000) ->  thermostat_finished = 1; goto t1;
        ::(pre_temperature < 250000000) -> temperature = (377800000 - pre_temperature) * 1000 / 10000000 + pre_temperature; thermostat_finished = 1; goto t2
        fi;

}
init {
    atomic {
         run thermostat_model();
         run clock_pro();
    }
}