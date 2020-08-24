// Global Variables 
double plant_x = 0;

// Plant Variables without mappings
double Plant_x = 0;

// Controller Variables without mappings
bit Controller_add1 = 0;
bit Controller_remove1 = 0;
bit Controller_add2 = 0;
bit Controller_remove2 = 0;
double Controller_y1 = 0;
double Controller_y2 = 0;


// Plant Variables with mappings
bit Plant_add1 = Controller_add1;
bit Plant_remove1 = Controller_remove1;
bit Plant_add2 = Controller_add2;
bit Plant_remove2 = Controller_remove2;

// Controller Variables with mappings
double Controller_x = Plant_x;

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
            pre_plant_x = plant_x;

            plant_x = 0;

    }
}

proctype Plant_model(){

    p1:  Plant_finished == 0 ->
        if
        ::(Plant_add1)plant_x = 550; Plant_finished == 1; goto p2;
        ::(Plant_add2)plant_x = 550; Plant_finished == 1; goto p3;
        ::else -> Plant_finished == 1; goto p1;
        fi

    p2:  Plant_finished == 0 ->
        if
        ::(Plant_remove1)plant_x = 510; Plant_finished == 1; goto p1;
        ::else -> Plant_finished == 1; goto p2;
        fi

    p3:  Plant_finished == 0 ->
        if
        ::(Plant_remove2)plant_x = 510; Plant_finished == 1; goto p1;
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