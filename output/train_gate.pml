int global_tick = 0
// Global Variables 
int train_pos = 0;
int gate_pos = 0;


// Gate Variables without mappings

// Train Variables without mappings
bool Train_gateRequestUp = 0;
bool Train_gateRequestDown = 0;
int Train_trainSpeed = 0;

int pre_train_pos = 0;
int pre_gate_pos = 0;

bit Gate_finished = 0;
bit Train_finished = 0;




proctype clock_pro(){

    INITIAL:
        if
        ::(global_tick == 1000000) -> skip;
        ::(Gate_finished == 1 && Train_finished == 1) ->
            d_step{
                global_tick++
                Gate_finished = 0; Train_finished = 0; 
                // ADD ASSERT STATEMENT CHECK HERE
                //if
                //:: (pre_x < y) -> assert(false)
                //:: else -> skip
                //fi
                pre_train_pos = train_pos;
pre_gate_pos = gate_pos;
            }
        goto INITIAL;
        fi;
}

proctype Gate_model(){

    g1:  (Gate_finished == 0) -> 
        if
        ::(Train_gateRequestUp) ->  Gate_finished = 1; goto g2;
        ::(Train_gateRequestUp == 0) -> gate_pos = ((0 - Gate_position) / 20000*10000) * 1 / 10000 + pre_gate_pos; Gate_finished = 1; goto g1
        fi;

    g2:  (Gate_finished == 0) -> 
        if
        ::(Train_gateRequestDown) ->  Gate_finished = 1; goto g1;
        ::(Train_gateRequestDown == 0) -> gate_pos = ((110000 - Gate_position) / 20000*10000) * 1 / 10000 + pre_gate_pos; Gate_finished = 1; goto g2
        fi;

}


proctype Train_model(){

    t1:  (Train_finished == 0) -> 
        if
        ::(Train_position == 50000) -> Train_gateRequestUp = (true); Train_gateRequestDown = (false);  Train_finished = 1; goto t2;
        ::(Train_position < 50000) -> train_pos = (Train_trainSpeed) * 1 / 10000 + pre_train_pos; Train_finished = 1; goto t1
        fi;

    t2:  (Train_finished == 0) -> 
        if
        ::(Train_position == 150000) -> Train_gateRequestUp = (false); Train_gateRequestDown = (true);  Train_finished = 1; goto t3;
        ::(Train_position >= 50000 && Train_position < 150000) -> train_pos = (Train_trainSpeed) * 1 / 10000 + pre_train_pos; Train_finished = 1; goto t2
        fi;

    t3:  (Train_finished == 0) -> 
        if
        ::(Train_position == 250000) -> train_pos = (0); Train_gateRequestUp = (false); Train_gateRequestDown = (false);  Train_finished = 1; goto t1;
        ::(Train_position >= 150000 && Train_position < 250000) -> train_pos = (Train_trainSpeed) * 1 / 10000 + pre_train_pos; Train_finished = 1; goto t3
        fi;

}
init {
    atomic {
         run Gate_model();
         run Train_model();
         run clock_pro();
    }
}