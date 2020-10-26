int global_tick = 0
// Global Variables 
int plant_x = 0;


// Plant Variables without mappings

// Controller Variables without mappings
bool Controller_add1 = 0;
bool Controller_remove1 = 0;
bool Controller_add2 = 0;
bool Controller_remove2 = 0;
int Controller_y1 = 0;
int Controller_y2 = 0;

int pre_plant_x = 0;

bit Plant_finished = 0;
bit Controller_finished = 0;




proctype clock_pro(){

    INITIAL:
        if
        ::(global_tick == 1000000) -> skip;
        ::(Plant_finished == 1 && Controller_finished == 1) ->
            d_step{
                global_tick++
                Plant_finished = 0; Controller_finished = 0; 
                // ADD ASSERT STATEMENT CHECK HERE
                //if
                //:: (pre_x < y) -> assert(false)
                //:: else -> skip
                //fi
                pre_plant_x = plant_x;
            }
        goto INITIAL;
        fi;
}

proctype Plant_model(){

    p1:  (Plant_finished == 0) -> 
        if
        ::(Controller_add1) -> plant_x = (5500000);  Plant_finished = 1; goto p2;
        ::(Controller_add2) -> plant_x = (5500000);  Plant_finished = 1; goto p3;
        ::(((Controller_add1 == 0) && (Controller_add2 == 0))) -> plant_x = (10000*pre_plant_x / 100000 - 500000) * 1 / 10000 + pre_plant_x; Plant_finished = 1; goto p1
        fi;

    p2:  (Plant_finished == 0) -> 
        if
        ::(Controller_remove1) -> plant_x = (5100000);  Plant_finished = 1; goto p1;
        ::((Controller_remove1 == 0)) -> plant_x = (10000*pre_plant_x / 100000 - 560000) * 1 / 10000 + pre_plant_x; Plant_finished = 1; goto p2
        fi;

    p3:  (Plant_finished == 0) -> 
        if
        ::(Controller_remove2) -> plant_x = (5100000);  Plant_finished = 1; goto p1;
        ::((Controller_remove2 == 0)) -> plant_x = ((1000 * pre_plant_x)/10000 - 600000) * 1 / 10000 + pre_plant_x; Plant_finished = 1; goto p3
        fi;

}


proctype Controller_model(){

    c1:  (Controller_finished == 0) -> 
        if
        ::((((pre_plant_x > 5500000) && (Controller_y1 >= 150000)) && (Controller_y2 < 150000))) -> Controller_add1 = (true); Controller_remove1 = (false); Controller_add2 = (false); Controller_remove2 = (false);  Controller_finished = 1; goto c2;
        ::(((pre_plant_x > 5500000) && (Controller_y2 >= 150000))) -> Controller_add1 = (false); Controller_remove1 = (false); Controller_add2 = (true); Controller_remove2 = (false);  Controller_finished = 1; goto c3;
        ::(((pre_plant_x <= 5500000) || (((Controller_y1 < 150000) && (Controller_y2 < 150000))))) -> Controller_y1 = (10000) * 1 / 10000 + Controller_y1; Controller_y2 = (10000) * 1 / 10000 + Controller_y2; Controller_finished = 1; goto c1
        fi;

    c2:  (Controller_finished == 0) -> 
        if
        ::((pre_plant_x <= 5100000)) -> Controller_add1 = (false); Controller_remove1 = (true); Controller_add2 = (false); Controller_remove2 = (false); Controller_y1 = (0);  Controller_finished = 1; goto c1;
        ::((pre_plant_x > 5100000)) -> Controller_y1 = (10000) * 1 / 10000 + Controller_y1; Controller_y2 = (10000) * 1 / 10000 + Controller_y2; Controller_finished = 1; goto c2
        fi;

    c3:  (Controller_finished == 0) -> 
        if
        ::((pre_plant_x <= 5100000)) -> Controller_add1 = (false); Controller_remove1 = (false); Controller_add2 = (false); Controller_remove2 = (true); Controller_y2 = (0);  Controller_finished = 1; goto c1;
        ::((pre_plant_x > 5100000)) -> Controller_y1 = (10000) * 1 / 10000 + Controller_y1; Controller_y2 = (10000) * 1 / 10000 + Controller_y2; Controller_finished = 1; goto c3
        fi;

}
init {
    atomic {
         run Plant_model();
         run Controller_model();
         run clock_pro();
    }
}