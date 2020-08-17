// Cell24 Variables without mappings

// Cell22 Variables without mappings

// Cell23 Variables without mappings

// Cell20 Variables without mappings

// Cell21 Variables without mappings

// Cell9 Variables without mappings

// Cell8 Variables without mappings

// Stimulator Variables without mappings

// Cell7 Variables without mappings

// Cell6 Variables without mappings

// Cell5 Variables without mappings

// Cell4 Variables without mappings

// Cell3 Variables without mappings

// Cell2 Variables without mappings

// Cell1 Variables without mappings

// Cell15 Variables without mappings

// Cell0 Variables without mappings

// Cell16 Variables without mappings

// Cell13 Variables without mappings

// Cell14 Variables without mappings

// Cell11 Variables without mappings

// Cell12 Variables without mappings

// Cell10 Variables without mappings

// Cell19 Variables without mappings

// Cell17 Variables without mappings

// Cell18 Variables without mappings

double cell_v = Cell24_v;

// Cell24 Variables with mappings

// Cell22 Variables with mappings

// Cell23 Variables with mappings

// Cell20 Variables with mappings

// Cell21 Variables with mappings

// Cell9 Variables with mappings

// Cell8 Variables with mappings

// Stimulator Variables with mappings

// Cell7 Variables with mappings

// Cell6 Variables with mappings

// Cell5 Variables with mappings

// Cell4 Variables with mappings

// Cell3 Variables with mappings

// Cell2 Variables with mappings

// Cell1 Variables with mappings

// Cell15 Variables with mappings

// Cell0 Variables with mappings

// Cell16 Variables with mappings

// Cell13 Variables with mappings

// Cell14 Variables with mappings

// Cell11 Variables with mappings

// Cell12 Variables with mappings

// Cell10 Variables with mappings

// Cell19 Variables with mappings

// Cell17 Variables with mappings

// Cell18 Variables with mappings
double cell_v = 0;

double pre_cell_v = 0;

bit Cell24_finished = 0;
bit Cell22_finished = 0;
bit Cell23_finished = 0;
bit Cell20_finished = 0;
bit Cell21_finished = 0;
bit Cell9_finished = 0;
bit Cell8_finished = 0;
bit Stimulator_finished = 0;
bit Cell7_finished = 0;
bit Cell6_finished = 0;
bit Cell5_finished = 0;
bit Cell4_finished = 0;
bit Cell3_finished = 0;
bit Cell2_finished = 0;
bit Cell1_finished = 0;
bit Cell15_finished = 0;
bit Cell0_finished = 0;
bit Cell16_finished = 0;
bit Cell13_finished = 0;
bit Cell14_finished = 0;
bit Cell11_finished = 0;
bit Cell12_finished = 0;
bit Cell10_finished = 0;
bit Cell19_finished = 0;
bit Cell17_finished = 0;
bit Cell18_finished = 0;

proctype clock_pro(){

    INITIAL: (Cell24_finished == 1 && Cell22_finished == 1 && Cell23_finished == 1 && Cell20_finished == 1 && Cell21_finished == 1 && Cell9_finished == 1 && Cell8_finished == 1 && Stimulator_finished == 1 && Cell7_finished == 1 && Cell6_finished == 1 && Cell5_finished == 1 && Cell4_finished == 1 && Cell3_finished == 1 && Cell2_finished == 1 && Cell1_finished == 1 && Cell15_finished == 1 && Cell0_finished == 1 && Cell16_finished == 1 && Cell13_finished == 1 && Cell14_finished == 1 && Cell11_finished == 1 && Cell12_finished == 1 && Cell10_finished == 1 && Cell19_finished == 1 && Cell17_finished == 1 && Cell18_finished == 1) ->
        d_step{
            Cell24_finished == 0; Cell22_finished == 0; Cell23_finished == 0; Cell20_finished == 0; Cell21_finished == 0; Cell9_finished == 0; Cell8_finished == 0; Stimulator_finished == 0; Cell7_finished == 0; Cell6_finished == 0; Cell5_finished == 0; Cell4_finished == 0; Cell3_finished == 0; Cell2_finished == 0; Cell1_finished == 0; Cell15_finished == 0; Cell0_finished == 0; Cell16_finished == 0; Cell13_finished == 0; Cell14_finished == 0; Cell11_finished == 0; Cell12_finished == 0; Cell10_finished == 0; Cell19_finished == 0; Cell17_finished == 0; Cell18_finished == 0; 
            // ADD ASSERT STATEMENT CHECK HERE
            //if
            //:: (pre_x < y) -> assert(false)
            //:: else -> skip
            //fi
            pre_cell_v = cell_v;

            cell_v = 0;

    }
}

proctype Cell24_model(){

    RP:  Cell24_finished == 0 ->
        if
        ::(Cell24_g >= Cell24_vT) Cell24_theta = Cell24_C3 / Cell24_t; Cell24_finished == 1; goto ST;
        ::else -> Cell24_finished == 1; goto RP;
        fi

    ST:  Cell24_finished == 0 ->
        if
        ::(Cell24_g <= 0 && Cell24_v < Cell24_vT) Cell24_finished == 1; goto RRP;
        ::(Cell24_v >= Cell24_vT) Cell24_finished == 1; goto UP;
        ::else -> Cell24_finished == 1; goto ST;
        fi

    UP:  Cell24_finished == 0 ->
        if
        ::(Cell24_v >= Cell24_vOmax - 80 * Cell24_theta) Cell24_finished == 1; goto ERP;
        ::else -> Cell24_finished == 1; goto UP;
        fi

    ERP:  Cell24_finished == 0 ->
        if
        ::(Cell24_v <= Cell24_vR) Cell24_t = 0; Cell24_finished == 1; goto RRP;
        ::else -> Cell24_finished == 1; goto ERP;
        fi

    RRP:  Cell24_finished == 0 ->
        if
        ::(Cell24_g >= Cell24_vT) Cell24_theta = Cell24_C3 / Cell24_t; Cell24_finished == 1; goto ST;
        ::else -> Cell24_finished == 1; goto RRP;
        fi

}


proctype Cell22_model(){

    RP:  Cell22_finished == 0 ->
        if
        ::(Cell22_g >= Cell22_vT) Cell22_theta = Cell22_C3 / Cell22_t; Cell22_finished == 1; goto ST;
        ::else -> Cell22_finished == 1; goto RP;
        fi

    ST:  Cell22_finished == 0 ->
        if
        ::(Cell22_g <= 0 && Cell22_v < Cell22_vT) Cell22_finished == 1; goto RRP;
        ::(Cell22_v >= Cell22_vT) Cell22_finished == 1; goto UP;
        ::else -> Cell22_finished == 1; goto ST;
        fi

    UP:  Cell22_finished == 0 ->
        if
        ::(Cell22_v >= Cell22_vOmax - 80 * Cell22_theta) Cell22_finished == 1; goto ERP;
        ::else -> Cell22_finished == 1; goto UP;
        fi

    ERP:  Cell22_finished == 0 ->
        if
        ::(Cell22_v <= Cell22_vR) Cell22_t = 0; Cell22_finished == 1; goto RRP;
        ::else -> Cell22_finished == 1; goto ERP;
        fi

    RRP:  Cell22_finished == 0 ->
        if
        ::(Cell22_g >= Cell22_vT) Cell22_theta = Cell22_C3 / Cell22_t; Cell22_finished == 1; goto ST;
        ::else -> Cell22_finished == 1; goto RRP;
        fi

}


proctype Cell23_model(){

    RP:  Cell23_finished == 0 ->
        if
        ::(Cell23_g >= Cell23_vT) Cell23_theta = Cell23_C3 / Cell23_t; Cell23_finished == 1; goto ST;
        ::else -> Cell23_finished == 1; goto RP;
        fi

    ST:  Cell23_finished == 0 ->
        if
        ::(Cell23_g <= 0 && Cell23_v < Cell23_vT) Cell23_finished == 1; goto RRP;
        ::(Cell23_v >= Cell23_vT) Cell23_finished == 1; goto UP;
        ::else -> Cell23_finished == 1; goto ST;
        fi

    UP:  Cell23_finished == 0 ->
        if
        ::(Cell23_v >= Cell23_vOmax - 80 * Cell23_theta) Cell23_finished == 1; goto ERP;
        ::else -> Cell23_finished == 1; goto UP;
        fi

    ERP:  Cell23_finished == 0 ->
        if
        ::(Cell23_v <= Cell23_vR) Cell23_t = 0; Cell23_finished == 1; goto RRP;
        ::else -> Cell23_finished == 1; goto ERP;
        fi

    RRP:  Cell23_finished == 0 ->
        if
        ::(Cell23_g >= Cell23_vT) Cell23_theta = Cell23_C3 / Cell23_t; Cell23_finished == 1; goto ST;
        ::else -> Cell23_finished == 1; goto RRP;
        fi

}


proctype Cell20_model(){

    RP:  Cell20_finished == 0 ->
        if
        ::(Cell20_g >= Cell20_vT) Cell20_theta = Cell20_C3 / Cell20_t; Cell20_finished == 1; goto ST;
        ::else -> Cell20_finished == 1; goto RP;
        fi

    ST:  Cell20_finished == 0 ->
        if
        ::(Cell20_g <= 0 && Cell20_v < Cell20_vT) Cell20_finished == 1; goto RRP;
        ::(Cell20_v >= Cell20_vT) Cell20_finished == 1; goto UP;
        ::else -> Cell20_finished == 1; goto ST;
        fi

    UP:  Cell20_finished == 0 ->
        if
        ::(Cell20_v >= Cell20_vOmax - 80 * Cell20_theta) Cell20_finished == 1; goto ERP;
        ::else -> Cell20_finished == 1; goto UP;
        fi

    ERP:  Cell20_finished == 0 ->
        if
        ::(Cell20_v <= Cell20_vR) Cell20_t = 0; Cell20_finished == 1; goto RRP;
        ::else -> Cell20_finished == 1; goto ERP;
        fi

    RRP:  Cell20_finished == 0 ->
        if
        ::(Cell20_g >= Cell20_vT) Cell20_theta = Cell20_C3 / Cell20_t; Cell20_finished == 1; goto ST;
        ::else -> Cell20_finished == 1; goto RRP;
        fi

}


proctype Cell21_model(){

    RP:  Cell21_finished == 0 ->
        if
        ::(Cell21_g >= Cell21_vT) Cell21_theta = Cell21_C3 / Cell21_t; Cell21_finished == 1; goto ST;
        ::else -> Cell21_finished == 1; goto RP;
        fi

    ST:  Cell21_finished == 0 ->
        if
        ::(Cell21_g <= 0 && Cell21_v < Cell21_vT) Cell21_finished == 1; goto RRP;
        ::(Cell21_v >= Cell21_vT) Cell21_finished == 1; goto UP;
        ::else -> Cell21_finished == 1; goto ST;
        fi

    UP:  Cell21_finished == 0 ->
        if
        ::(Cell21_v >= Cell21_vOmax - 80 * Cell21_theta) Cell21_finished == 1; goto ERP;
        ::else -> Cell21_finished == 1; goto UP;
        fi

    ERP:  Cell21_finished == 0 ->
        if
        ::(Cell21_v <= Cell21_vR) Cell21_t = 0; Cell21_finished == 1; goto RRP;
        ::else -> Cell21_finished == 1; goto ERP;
        fi

    RRP:  Cell21_finished == 0 ->
        if
        ::(Cell21_g >= Cell21_vT) Cell21_theta = Cell21_C3 / Cell21_t; Cell21_finished == 1; goto ST;
        ::else -> Cell21_finished == 1; goto RRP;
        fi

}


proctype Cell9_model(){

    RP:  Cell9_finished == 0 ->
        if
        ::(Cell9_g >= Cell9_vT) Cell9_theta = Cell9_C3 / Cell9_t; Cell9_finished == 1; goto ST;
        ::else -> Cell9_finished == 1; goto RP;
        fi

    ST:  Cell9_finished == 0 ->
        if
        ::(Cell9_g <= 0 && Cell9_v < Cell9_vT) Cell9_finished == 1; goto RRP;
        ::(Cell9_v >= Cell9_vT) Cell9_finished == 1; goto UP;
        ::else -> Cell9_finished == 1; goto ST;
        fi

    UP:  Cell9_finished == 0 ->
        if
        ::(Cell9_v >= Cell9_vOmax - 80 * Cell9_theta) Cell9_finished == 1; goto ERP;
        ::else -> Cell9_finished == 1; goto UP;
        fi

    ERP:  Cell9_finished == 0 ->
        if
        ::(Cell9_v <= Cell9_vR) Cell9_t = 0; Cell9_finished == 1; goto RRP;
        ::else -> Cell9_finished == 1; goto ERP;
        fi

    RRP:  Cell9_finished == 0 ->
        if
        ::(Cell9_g >= Cell9_vT) Cell9_theta = Cell9_C3 / Cell9_t; Cell9_finished == 1; goto ST;
        ::else -> Cell9_finished == 1; goto RRP;
        fi

}


proctype Cell8_model(){

    RP:  Cell8_finished == 0 ->
        if
        ::(Cell8_g >= Cell8_vT) Cell8_theta = Cell8_C3 / Cell8_t; Cell8_finished == 1; goto ST;
        ::else -> Cell8_finished == 1; goto RP;
        fi

    ST:  Cell8_finished == 0 ->
        if
        ::(Cell8_g <= 0 && Cell8_v < Cell8_vT) Cell8_finished == 1; goto RRP;
        ::(Cell8_v >= Cell8_vT) Cell8_finished == 1; goto UP;
        ::else -> Cell8_finished == 1; goto ST;
        fi

    UP:  Cell8_finished == 0 ->
        if
        ::(Cell8_v >= Cell8_vOmax - 80 * Cell8_theta) Cell8_finished == 1; goto ERP;
        ::else -> Cell8_finished == 1; goto UP;
        fi

    ERP:  Cell8_finished == 0 ->
        if
        ::(Cell8_v <= Cell8_vR) Cell8_t = 0; Cell8_finished == 1; goto RRP;
        ::else -> Cell8_finished == 1; goto ERP;
        fi

    RRP:  Cell8_finished == 0 ->
        if
        ::(Cell8_g >= Cell8_vT) Cell8_theta = Cell8_C3 / Cell8_t; Cell8_finished == 1; goto ST;
        ::else -> Cell8_finished == 1; goto RRP;
        fi

}


proctype Stimulator_model(){

    count:  Stimulator_finished == 0 ->
        if
        ::(Stimulator_t >= Stimulator_rate) Stimulator_t = 0; Stimulator_v = Stimulator_amplitude; Stimulator_finished == 1; goto stimulate;
        ::else -> Stimulator_finished == 1; goto count;
        fi

    stimulate:  Stimulator_finished == 0 ->
        if
        ::(Stimulator_t >= Stimulator_pulse_width) Stimulator_t = 0; Stimulator_v = 0; Stimulator_finished == 1; goto count;
        ::else -> Stimulator_finished == 1; goto stimulate;
        fi

}


proctype Cell7_model(){

    RP:  Cell7_finished == 0 ->
        if
        ::(Cell7_g >= Cell7_vT) Cell7_theta = Cell7_C3 / Cell7_t; Cell7_finished == 1; goto ST;
        ::else -> Cell7_finished == 1; goto RP;
        fi

    ST:  Cell7_finished == 0 ->
        if
        ::(Cell7_g <= 0 && Cell7_v < Cell7_vT) Cell7_finished == 1; goto RRP;
        ::(Cell7_v >= Cell7_vT) Cell7_finished == 1; goto UP;
        ::else -> Cell7_finished == 1; goto ST;
        fi

    UP:  Cell7_finished == 0 ->
        if
        ::(Cell7_v >= Cell7_vOmax - 80 * Cell7_theta) Cell7_finished == 1; goto ERP;
        ::else -> Cell7_finished == 1; goto UP;
        fi

    ERP:  Cell7_finished == 0 ->
        if
        ::(Cell7_v <= Cell7_vR) Cell7_t = 0; Cell7_finished == 1; goto RRP;
        ::else -> Cell7_finished == 1; goto ERP;
        fi

    RRP:  Cell7_finished == 0 ->
        if
        ::(Cell7_g >= Cell7_vT) Cell7_theta = Cell7_C3 / Cell7_t; Cell7_finished == 1; goto ST;
        ::else -> Cell7_finished == 1; goto RRP;
        fi

}


proctype Cell6_model(){

    RP:  Cell6_finished == 0 ->
        if
        ::(Cell6_g >= Cell6_vT) Cell6_theta = Cell6_C3 / Cell6_t; Cell6_finished == 1; goto ST;
        ::else -> Cell6_finished == 1; goto RP;
        fi

    ST:  Cell6_finished == 0 ->
        if
        ::(Cell6_g <= 0 && Cell6_v < Cell6_vT) Cell6_finished == 1; goto RRP;
        ::(Cell6_v >= Cell6_vT) Cell6_finished == 1; goto UP;
        ::else -> Cell6_finished == 1; goto ST;
        fi

    UP:  Cell6_finished == 0 ->
        if
        ::(Cell6_v >= Cell6_vOmax - 80 * Cell6_theta) Cell6_finished == 1; goto ERP;
        ::else -> Cell6_finished == 1; goto UP;
        fi

    ERP:  Cell6_finished == 0 ->
        if
        ::(Cell6_v <= Cell6_vR) Cell6_t = 0; Cell6_finished == 1; goto RRP;
        ::else -> Cell6_finished == 1; goto ERP;
        fi

    RRP:  Cell6_finished == 0 ->
        if
        ::(Cell6_g >= Cell6_vT) Cell6_theta = Cell6_C3 / Cell6_t; Cell6_finished == 1; goto ST;
        ::else -> Cell6_finished == 1; goto RRP;
        fi

}


proctype Cell5_model(){

    RP:  Cell5_finished == 0 ->
        if
        ::(Cell5_g >= Cell5_vT) Cell5_theta = Cell5_C3 / Cell5_t; Cell5_finished == 1; goto ST;
        ::else -> Cell5_finished == 1; goto RP;
        fi

    ST:  Cell5_finished == 0 ->
        if
        ::(Cell5_g <= 0 && Cell5_v < Cell5_vT) Cell5_finished == 1; goto RRP;
        ::(Cell5_v >= Cell5_vT) Cell5_finished == 1; goto UP;
        ::else -> Cell5_finished == 1; goto ST;
        fi

    UP:  Cell5_finished == 0 ->
        if
        ::(Cell5_v >= Cell5_vOmax - 80 * Cell5_theta) Cell5_finished == 1; goto ERP;
        ::else -> Cell5_finished == 1; goto UP;
        fi

    ERP:  Cell5_finished == 0 ->
        if
        ::(Cell5_v <= Cell5_vR) Cell5_t = 0; Cell5_finished == 1; goto RRP;
        ::else -> Cell5_finished == 1; goto ERP;
        fi

    RRP:  Cell5_finished == 0 ->
        if
        ::(Cell5_g >= Cell5_vT) Cell5_theta = Cell5_C3 / Cell5_t; Cell5_finished == 1; goto ST;
        ::else -> Cell5_finished == 1; goto RRP;
        fi

}


proctype Cell4_model(){

    RP:  Cell4_finished == 0 ->
        if
        ::(Cell4_g >= Cell4_vT) Cell4_theta = Cell4_C3 / Cell4_t; Cell4_finished == 1; goto ST;
        ::else -> Cell4_finished == 1; goto RP;
        fi

    ST:  Cell4_finished == 0 ->
        if
        ::(Cell4_g <= 0 && Cell4_v < Cell4_vT) Cell4_finished == 1; goto RRP;
        ::(Cell4_v >= Cell4_vT) Cell4_finished == 1; goto UP;
        ::else -> Cell4_finished == 1; goto ST;
        fi

    UP:  Cell4_finished == 0 ->
        if
        ::(Cell4_v >= Cell4_vOmax - 80 * Cell4_theta) Cell4_finished == 1; goto ERP;
        ::else -> Cell4_finished == 1; goto UP;
        fi

    ERP:  Cell4_finished == 0 ->
        if
        ::(Cell4_v <= Cell4_vR) Cell4_t = 0; Cell4_finished == 1; goto RRP;
        ::else -> Cell4_finished == 1; goto ERP;
        fi

    RRP:  Cell4_finished == 0 ->
        if
        ::(Cell4_g >= Cell4_vT) Cell4_theta = Cell4_C3 / Cell4_t; Cell4_finished == 1; goto ST;
        ::else -> Cell4_finished == 1; goto RRP;
        fi

}


proctype Cell3_model(){

    RP:  Cell3_finished == 0 ->
        if
        ::(Cell3_g >= Cell3_vT) Cell3_theta = Cell3_C3 / Cell3_t; Cell3_finished == 1; goto ST;
        ::else -> Cell3_finished == 1; goto RP;
        fi

    ST:  Cell3_finished == 0 ->
        if
        ::(Cell3_g <= 0 && Cell3_v < Cell3_vT) Cell3_finished == 1; goto RRP;
        ::(Cell3_v >= Cell3_vT) Cell3_finished == 1; goto UP;
        ::else -> Cell3_finished == 1; goto ST;
        fi

    UP:  Cell3_finished == 0 ->
        if
        ::(Cell3_v >= Cell3_vOmax - 80 * Cell3_theta) Cell3_finished == 1; goto ERP;
        ::else -> Cell3_finished == 1; goto UP;
        fi

    ERP:  Cell3_finished == 0 ->
        if
        ::(Cell3_v <= Cell3_vR) Cell3_t = 0; Cell3_finished == 1; goto RRP;
        ::else -> Cell3_finished == 1; goto ERP;
        fi

    RRP:  Cell3_finished == 0 ->
        if
        ::(Cell3_g >= Cell3_vT) Cell3_theta = Cell3_C3 / Cell3_t; Cell3_finished == 1; goto ST;
        ::else -> Cell3_finished == 1; goto RRP;
        fi

}


proctype Cell2_model(){

    RP:  Cell2_finished == 0 ->
        if
        ::(Cell2_g >= Cell2_vT) Cell2_theta = Cell2_C3 / Cell2_t; Cell2_finished == 1; goto ST;
        ::else -> Cell2_finished == 1; goto RP;
        fi

    ST:  Cell2_finished == 0 ->
        if
        ::(Cell2_g <= 0 && Cell2_v < Cell2_vT) Cell2_finished == 1; goto RRP;
        ::(Cell2_v >= Cell2_vT) Cell2_finished == 1; goto UP;
        ::else -> Cell2_finished == 1; goto ST;
        fi

    UP:  Cell2_finished == 0 ->
        if
        ::(Cell2_v >= Cell2_vOmax - 80 * Cell2_theta) Cell2_finished == 1; goto ERP;
        ::else -> Cell2_finished == 1; goto UP;
        fi

    ERP:  Cell2_finished == 0 ->
        if
        ::(Cell2_v <= Cell2_vR) Cell2_t = 0; Cell2_finished == 1; goto RRP;
        ::else -> Cell2_finished == 1; goto ERP;
        fi

    RRP:  Cell2_finished == 0 ->
        if
        ::(Cell2_g >= Cell2_vT) Cell2_theta = Cell2_C3 / Cell2_t; Cell2_finished == 1; goto ST;
        ::else -> Cell2_finished == 1; goto RRP;
        fi

}


proctype Cell1_model(){

    RP:  Cell1_finished == 0 ->
        if
        ::(Cell1_g >= Cell1_vT) Cell1_theta = Cell1_C3 / Cell1_t; Cell1_finished == 1; goto ST;
        ::else -> Cell1_finished == 1; goto RP;
        fi

    ST:  Cell1_finished == 0 ->
        if
        ::(Cell1_g <= 0 && Cell1_v < Cell1_vT) Cell1_finished == 1; goto RRP;
        ::(Cell1_v >= Cell1_vT) Cell1_finished == 1; goto UP;
        ::else -> Cell1_finished == 1; goto ST;
        fi

    UP:  Cell1_finished == 0 ->
        if
        ::(Cell1_v >= Cell1_vOmax - 80 * Cell1_theta) Cell1_finished == 1; goto ERP;
        ::else -> Cell1_finished == 1; goto UP;
        fi

    ERP:  Cell1_finished == 0 ->
        if
        ::(Cell1_v <= Cell1_vR) Cell1_t = 0; Cell1_finished == 1; goto RRP;
        ::else -> Cell1_finished == 1; goto ERP;
        fi

    RRP:  Cell1_finished == 0 ->
        if
        ::(Cell1_g >= Cell1_vT) Cell1_theta = Cell1_C3 / Cell1_t; Cell1_finished == 1; goto ST;
        ::else -> Cell1_finished == 1; goto RRP;
        fi

}


proctype Cell15_model(){

    RP:  Cell15_finished == 0 ->
        if
        ::(Cell15_g >= Cell15_vT) Cell15_theta = Cell15_C3 / Cell15_t; Cell15_finished == 1; goto ST;
        ::else -> Cell15_finished == 1; goto RP;
        fi

    ST:  Cell15_finished == 0 ->
        if
        ::(Cell15_g <= 0 && Cell15_v < Cell15_vT) Cell15_finished == 1; goto RRP;
        ::(Cell15_v >= Cell15_vT) Cell15_finished == 1; goto UP;
        ::else -> Cell15_finished == 1; goto ST;
        fi

    UP:  Cell15_finished == 0 ->
        if
        ::(Cell15_v >= Cell15_vOmax - 80 * Cell15_theta) Cell15_finished == 1; goto ERP;
        ::else -> Cell15_finished == 1; goto UP;
        fi

    ERP:  Cell15_finished == 0 ->
        if
        ::(Cell15_v <= Cell15_vR) Cell15_t = 0; Cell15_finished == 1; goto RRP;
        ::else -> Cell15_finished == 1; goto ERP;
        fi

    RRP:  Cell15_finished == 0 ->
        if
        ::(Cell15_g >= Cell15_vT) Cell15_theta = Cell15_C3 / Cell15_t; Cell15_finished == 1; goto ST;
        ::else -> Cell15_finished == 1; goto RRP;
        fi

}


proctype Cell0_model(){

    RP:  Cell0_finished == 0 ->
        if
        ::(Cell0_g >= Cell0_vT) Cell0_theta = Cell0_C3 / Cell0_t; Cell0_finished == 1; goto ST;
        ::else -> Cell0_finished == 1; goto RP;
        fi

    ST:  Cell0_finished == 0 ->
        if
        ::(Cell0_g <= 0 && Cell0_v < Cell0_vT) Cell0_finished == 1; goto RRP;
        ::(Cell0_v >= Cell0_vT) Cell0_finished == 1; goto UP;
        ::else -> Cell0_finished == 1; goto ST;
        fi

    UP:  Cell0_finished == 0 ->
        if
        ::(Cell0_v >= Cell0_vOmax - 80 * Cell0_theta) Cell0_finished == 1; goto ERP;
        ::else -> Cell0_finished == 1; goto UP;
        fi

    ERP:  Cell0_finished == 0 ->
        if
        ::(Cell0_v <= Cell0_vR) Cell0_t = 0; Cell0_finished == 1; goto RRP;
        ::else -> Cell0_finished == 1; goto ERP;
        fi

    RRP:  Cell0_finished == 0 ->
        if
        ::(Cell0_g >= Cell0_vT) Cell0_theta = Cell0_C3 / Cell0_t; Cell0_finished == 1; goto ST;
        ::else -> Cell0_finished == 1; goto RRP;
        fi

}


proctype Cell16_model(){

    RP:  Cell16_finished == 0 ->
        if
        ::(Cell16_g >= Cell16_vT) Cell16_theta = Cell16_C3 / Cell16_t; Cell16_finished == 1; goto ST;
        ::else -> Cell16_finished == 1; goto RP;
        fi

    ST:  Cell16_finished == 0 ->
        if
        ::(Cell16_g <= 0 && Cell16_v < Cell16_vT) Cell16_finished == 1; goto RRP;
        ::(Cell16_v >= Cell16_vT) Cell16_finished == 1; goto UP;
        ::else -> Cell16_finished == 1; goto ST;
        fi

    UP:  Cell16_finished == 0 ->
        if
        ::(Cell16_v >= Cell16_vOmax - 80 * Cell16_theta) Cell16_finished == 1; goto ERP;
        ::else -> Cell16_finished == 1; goto UP;
        fi

    ERP:  Cell16_finished == 0 ->
        if
        ::(Cell16_v <= Cell16_vR) Cell16_t = 0; Cell16_finished == 1; goto RRP;
        ::else -> Cell16_finished == 1; goto ERP;
        fi

    RRP:  Cell16_finished == 0 ->
        if
        ::(Cell16_g >= Cell16_vT) Cell16_theta = Cell16_C3 / Cell16_t; Cell16_finished == 1; goto ST;
        ::else -> Cell16_finished == 1; goto RRP;
        fi

}


proctype Cell13_model(){

    RP:  Cell13_finished == 0 ->
        if
        ::(Cell13_g >= Cell13_vT) Cell13_theta = Cell13_C3 / Cell13_t; Cell13_finished == 1; goto ST;
        ::else -> Cell13_finished == 1; goto RP;
        fi

    ST:  Cell13_finished == 0 ->
        if
        ::(Cell13_g <= 0 && Cell13_v < Cell13_vT) Cell13_finished == 1; goto RRP;
        ::(Cell13_v >= Cell13_vT) Cell13_finished == 1; goto UP;
        ::else -> Cell13_finished == 1; goto ST;
        fi

    UP:  Cell13_finished == 0 ->
        if
        ::(Cell13_v >= Cell13_vOmax - 80 * Cell13_theta) Cell13_finished == 1; goto ERP;
        ::else -> Cell13_finished == 1; goto UP;
        fi

    ERP:  Cell13_finished == 0 ->
        if
        ::(Cell13_v <= Cell13_vR) Cell13_t = 0; Cell13_finished == 1; goto RRP;
        ::else -> Cell13_finished == 1; goto ERP;
        fi

    RRP:  Cell13_finished == 0 ->
        if
        ::(Cell13_g >= Cell13_vT) Cell13_theta = Cell13_C3 / Cell13_t; Cell13_finished == 1; goto ST;
        ::else -> Cell13_finished == 1; goto RRP;
        fi

}


proctype Cell14_model(){

    RP:  Cell14_finished == 0 ->
        if
        ::(Cell14_g >= Cell14_vT) Cell14_theta = Cell14_C3 / Cell14_t; Cell14_finished == 1; goto ST;
        ::else -> Cell14_finished == 1; goto RP;
        fi

    ST:  Cell14_finished == 0 ->
        if
        ::(Cell14_g <= 0 && Cell14_v < Cell14_vT) Cell14_finished == 1; goto RRP;
        ::(Cell14_v >= Cell14_vT) Cell14_finished == 1; goto UP;
        ::else -> Cell14_finished == 1; goto ST;
        fi

    UP:  Cell14_finished == 0 ->
        if
        ::(Cell14_v >= Cell14_vOmax - 80 * Cell14_theta) Cell14_finished == 1; goto ERP;
        ::else -> Cell14_finished == 1; goto UP;
        fi

    ERP:  Cell14_finished == 0 ->
        if
        ::(Cell14_v <= Cell14_vR) Cell14_t = 0; Cell14_finished == 1; goto RRP;
        ::else -> Cell14_finished == 1; goto ERP;
        fi

    RRP:  Cell14_finished == 0 ->
        if
        ::(Cell14_g >= Cell14_vT) Cell14_theta = Cell14_C3 / Cell14_t; Cell14_finished == 1; goto ST;
        ::else -> Cell14_finished == 1; goto RRP;
        fi

}


proctype Cell11_model(){

    RP:  Cell11_finished == 0 ->
        if
        ::(Cell11_g >= Cell11_vT) Cell11_theta = Cell11_C3 / Cell11_t; Cell11_finished == 1; goto ST;
        ::else -> Cell11_finished == 1; goto RP;
        fi

    ST:  Cell11_finished == 0 ->
        if
        ::(Cell11_g <= 0 && Cell11_v < Cell11_vT) Cell11_finished == 1; goto RRP;
        ::(Cell11_v >= Cell11_vT) Cell11_finished == 1; goto UP;
        ::else -> Cell11_finished == 1; goto ST;
        fi

    UP:  Cell11_finished == 0 ->
        if
        ::(Cell11_v >= Cell11_vOmax - 80 * Cell11_theta) Cell11_finished == 1; goto ERP;
        ::else -> Cell11_finished == 1; goto UP;
        fi

    ERP:  Cell11_finished == 0 ->
        if
        ::(Cell11_v <= Cell11_vR) Cell11_t = 0; Cell11_finished == 1; goto RRP;
        ::else -> Cell11_finished == 1; goto ERP;
        fi

    RRP:  Cell11_finished == 0 ->
        if
        ::(Cell11_g >= Cell11_vT) Cell11_theta = Cell11_C3 / Cell11_t; Cell11_finished == 1; goto ST;
        ::else -> Cell11_finished == 1; goto RRP;
        fi

}


proctype Cell12_model(){

    RP:  Cell12_finished == 0 ->
        if
        ::(Cell12_g >= Cell12_vT) Cell12_theta = Cell12_C3 / Cell12_t; Cell12_finished == 1; goto ST;
        ::else -> Cell12_finished == 1; goto RP;
        fi

    ST:  Cell12_finished == 0 ->
        if
        ::(Cell12_g <= 0 && Cell12_v < Cell12_vT) Cell12_finished == 1; goto RRP;
        ::(Cell12_v >= Cell12_vT) Cell12_finished == 1; goto UP;
        ::else -> Cell12_finished == 1; goto ST;
        fi

    UP:  Cell12_finished == 0 ->
        if
        ::(Cell12_v >= Cell12_vOmax - 80 * Cell12_theta) Cell12_finished == 1; goto ERP;
        ::else -> Cell12_finished == 1; goto UP;
        fi

    ERP:  Cell12_finished == 0 ->
        if
        ::(Cell12_v <= Cell12_vR) Cell12_t = 0; Cell12_finished == 1; goto RRP;
        ::else -> Cell12_finished == 1; goto ERP;
        fi

    RRP:  Cell12_finished == 0 ->
        if
        ::(Cell12_g >= Cell12_vT) Cell12_theta = Cell12_C3 / Cell12_t; Cell12_finished == 1; goto ST;
        ::else -> Cell12_finished == 1; goto RRP;
        fi

}


proctype Cell10_model(){

    RP:  Cell10_finished == 0 ->
        if
        ::(Cell10_g >= Cell10_vT) Cell10_theta = Cell10_C3 / Cell10_t; Cell10_finished == 1; goto ST;
        ::else -> Cell10_finished == 1; goto RP;
        fi

    ST:  Cell10_finished == 0 ->
        if
        ::(Cell10_g <= 0 && Cell10_v < Cell10_vT) Cell10_finished == 1; goto RRP;
        ::(Cell10_v >= Cell10_vT) Cell10_finished == 1; goto UP;
        ::else -> Cell10_finished == 1; goto ST;
        fi

    UP:  Cell10_finished == 0 ->
        if
        ::(Cell10_v >= Cell10_vOmax - 80 * Cell10_theta) Cell10_finished == 1; goto ERP;
        ::else -> Cell10_finished == 1; goto UP;
        fi

    ERP:  Cell10_finished == 0 ->
        if
        ::(Cell10_v <= Cell10_vR) Cell10_t = 0; Cell10_finished == 1; goto RRP;
        ::else -> Cell10_finished == 1; goto ERP;
        fi

    RRP:  Cell10_finished == 0 ->
        if
        ::(Cell10_g >= Cell10_vT) Cell10_theta = Cell10_C3 / Cell10_t; Cell10_finished == 1; goto ST;
        ::else -> Cell10_finished == 1; goto RRP;
        fi

}


proctype Cell19_model(){

    RP:  Cell19_finished == 0 ->
        if
        ::(Cell19_g >= Cell19_vT) Cell19_theta = Cell19_C3 / Cell19_t; Cell19_finished == 1; goto ST;
        ::else -> Cell19_finished == 1; goto RP;
        fi

    ST:  Cell19_finished == 0 ->
        if
        ::(Cell19_g <= 0 && Cell19_v < Cell19_vT) Cell19_finished == 1; goto RRP;
        ::(Cell19_v >= Cell19_vT) Cell19_finished == 1; goto UP;
        ::else -> Cell19_finished == 1; goto ST;
        fi

    UP:  Cell19_finished == 0 ->
        if
        ::(Cell19_v >= Cell19_vOmax - 80 * Cell19_theta) Cell19_finished == 1; goto ERP;
        ::else -> Cell19_finished == 1; goto UP;
        fi

    ERP:  Cell19_finished == 0 ->
        if
        ::(Cell19_v <= Cell19_vR) Cell19_t = 0; Cell19_finished == 1; goto RRP;
        ::else -> Cell19_finished == 1; goto ERP;
        fi

    RRP:  Cell19_finished == 0 ->
        if
        ::(Cell19_g >= Cell19_vT) Cell19_theta = Cell19_C3 / Cell19_t; Cell19_finished == 1; goto ST;
        ::else -> Cell19_finished == 1; goto RRP;
        fi

}


proctype Cell17_model(){

    RP:  Cell17_finished == 0 ->
        if
        ::(Cell17_g >= Cell17_vT) Cell17_theta = Cell17_C3 / Cell17_t; Cell17_finished == 1; goto ST;
        ::else -> Cell17_finished == 1; goto RP;
        fi

    ST:  Cell17_finished == 0 ->
        if
        ::(Cell17_g <= 0 && Cell17_v < Cell17_vT) Cell17_finished == 1; goto RRP;
        ::(Cell17_v >= Cell17_vT) Cell17_finished == 1; goto UP;
        ::else -> Cell17_finished == 1; goto ST;
        fi

    UP:  Cell17_finished == 0 ->
        if
        ::(Cell17_v >= Cell17_vOmax - 80 * Cell17_theta) Cell17_finished == 1; goto ERP;
        ::else -> Cell17_finished == 1; goto UP;
        fi

    ERP:  Cell17_finished == 0 ->
        if
        ::(Cell17_v <= Cell17_vR) Cell17_t = 0; Cell17_finished == 1; goto RRP;
        ::else -> Cell17_finished == 1; goto ERP;
        fi

    RRP:  Cell17_finished == 0 ->
        if
        ::(Cell17_g >= Cell17_vT) Cell17_theta = Cell17_C3 / Cell17_t; Cell17_finished == 1; goto ST;
        ::else -> Cell17_finished == 1; goto RRP;
        fi

}


proctype Cell18_model(){

    RP:  Cell18_finished == 0 ->
        if
        ::(Cell18_g >= Cell18_vT) Cell18_theta = Cell18_C3 / Cell18_t; Cell18_finished == 1; goto ST;
        ::else -> Cell18_finished == 1; goto RP;
        fi

    ST:  Cell18_finished == 0 ->
        if
        ::(Cell18_g <= 0 && Cell18_v < Cell18_vT) Cell18_finished == 1; goto RRP;
        ::(Cell18_v >= Cell18_vT) Cell18_finished == 1; goto UP;
        ::else -> Cell18_finished == 1; goto ST;
        fi

    UP:  Cell18_finished == 0 ->
        if
        ::(Cell18_v >= Cell18_vOmax - 80 * Cell18_theta) Cell18_finished == 1; goto ERP;
        ::else -> Cell18_finished == 1; goto UP;
        fi

    ERP:  Cell18_finished == 0 ->
        if
        ::(Cell18_v <= Cell18_vR) Cell18_t = 0; Cell18_finished == 1; goto RRP;
        ::else -> Cell18_finished == 1; goto ERP;
        fi

    RRP:  Cell18_finished == 0 ->
        if
        ::(Cell18_g >= Cell18_vT) Cell18_theta = Cell18_C3 / Cell18_t; Cell18_finished == 1; goto ST;
        ::else -> Cell18_finished == 1; goto RRP;
        fi

}