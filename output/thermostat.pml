// Network Variables
double temperature = 20;


// thermostat Variables

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

    t1:  thermostat_finished == 0 ->
        if
        ::(pre_temperature <= 22.78) thermostat_finished == 1; goto t2;
        ::else -> thermostat_finished == 1; goto t1;
        fi

    t2:  thermostat_finished == 0 ->
        if
        ::(pre_temperature >= 25) thermostat_finished == 1; goto t1;
        ::else -> thermostat_finished == 1; goto t2;
        fi

}