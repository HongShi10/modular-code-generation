// Plant Variables without mappings

// Controller Variables without mappings

// Global Variables with mappings
double plant_x = Plant_x;

// Plant Variables with mappings

// Controller Variables with mappings
double plant_x = 0;

double pre_plant_x = 0;

bit Plant_finished = 0;
bit Controller_finished = 0;

proctype clock_pro(){

    INITIAL: (Plant_finished == 1 && Controller_finished == 1) ->
        d_step{
            Plant_finished == 0; Controller_finished == 0; 
            // ADD ASSERT STATEMENT CHECK HERE
            //if
            //:: (pre_x < y) -> assert(false)
            //:: else -> skip
            //fi
// Global Variables with mappings
            plant_x = Plant_x;
            pre_plant_x = plant_x;

            plant_x = 0;

    }
}

proctype Plant_model(){

    p1:  Plant_finished == 0 ->
        if
        ::(Plant_add1) Plant_x = 550; Plant_finished == 1; goto p2;
        ::(Plant_add2) Plant_x = 550; Plant_finished == 1; goto p3;
        ::else -> Plant_finished == 1; goto p1;
        fi

    p2:  Plant_finished == 0 ->
        if
        ::(Plant_remove1) Plant_x = 510; Plant_finished == 1; goto p1;
        ::else -> Plant_finished == 1; goto p2;
        fi

    p3:  Plant_finished == 0 ->
        if
        ::(Plant_remove2) Plant_x = 510; Plant_finished == 1; goto p1;
        ::else -> Plant_finished == 1; goto p3;
        fi

}


proctype Controller_model(){

    c1:  Controller_finished == 0 ->
        if
        ::(Controller_x > 550 && Controller_y1 >= 15 && Controller_y2 < 15) Controller_add1 = true; Controller_remove1 = false; Controller_add2 = false; Controller_remove2 = false; Controller_finished == 1; goto c2;
        ::(Controller_x > 550 && Controller_y2 >= 15) Controller_add1 = false; Controller_remove1 = false; Controller_add2 = true; Controller_remove2 = false; Controller_finished == 1; goto c3;
        ::else -> Controller_finished == 1; goto c1;
        fi

    c2:  Controller_finished == 0 ->
        if
        ::(Controller_x <= 510) Controller_add1 = false; Controller_remove1 = true; Controller_add2 = false; Controller_remove2 = false; Controller_y1 = 0; Controller_finished == 1; goto c1;
        ::else -> Controller_finished == 1; goto c2;
        fi

    c3:  Controller_finished == 0 ->
        if
        ::(Controller_x <= 510) Controller_add1 = false; Controller_remove1 = false; Controller_add2 = false; Controller_remove2 = true; Controller_y2 = 0; Controller_finished == 1; goto c1;
        ::else -> Controller_finished == 1; goto c3;
        fi

}