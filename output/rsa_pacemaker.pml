bit inspiration = 0;

// RSA Variables without mappings
bit RSA_INS = 0;
double RSA_value = 0;
bit RSA_toggle = 0;
bit RSA_APED = 0;
bit RSA_INSED = 0;
double RSA_t = 0;

// LRI Variables without mappings
bit LRI_INS = 0;
bit LRI_AP = 0;
double LRI_AEI = 0;
double LRI_t = 0;

// AVI Variables without mappings
bit AVI_VP = 0;
double AVI_t = 0;
double AVI_TURI = 0;
double AVI_TAVI = 0;

// VRP Variables without mappings
bit VRP_VS = 0;
double VRP_TVRP = 0;
double VRP_t = 0;

// RHM Variables without mappings
bit RHM_Aget = 0;
bit RHM_Vget = 0;
double RHM_TAV = 0;
double RHM_TVA = 0;
double RHM_t = 0;

// PVARP Variables without mappings
bit PVARP_AS = 0;
bit PVARP_AR = 0;
double PVARP_TPVAB = 0;
double PVARP_TPVARP = 0;
double PVARP_t = 0;

// URI Variables without mappings
double URI_clk = 0;

// Global Variables with mappings
bit AP = LRI_AP;
bit VP = AVI_VP;
bit AS = PVARP_AS;
bit VS = VRP_VS;
double time = AVI_t;
double AEI = LRI_AEI;
double pacing_rate = LRI_t;
double toggle_value = RSA_toggle;
double value_value = RSA_value;
double clock = URI_clk;

// RSA Variables with mappings

// LRI Variables with mappings
bit LRI_toggle = RSA_toggle;
double LRI_value = RSA_value;
double LRI_current_AEI = LRI_AEI;

// AVI Variables with mappings
double AVI_clk = URI_clk;

// VRP Variables with mappings
bit VRP_Vget = RHM_Vget;

// RHM Variables with mappings

// PVARP Variables with mappings
bit PVARP_Aget = RHM_Aget;

// URI Variables with mappings

bit pre_AP = 0;
bit pre_VP = 0;
bit pre_AS = 0;
bit pre_VS = 0;
double pre_time = 0;
bit pre_inspiration = 0;
double pre_AEI = 0;
double pre_pacing_rate = 0;
double pre_toggle_value = 0;
double pre_value_value = 0;
double pre_clock = 0;

bit RSA_finished = 0;
bit LRI_finished = 0;
bit AVI_finished = 0;
bit VRP_finished = 0;
bit RHM_finished = 0;
bit PVARP_finished = 0;
bit URI_finished = 0;


proctype clock_pro(){

    INITIAL: (RSA_finished == 1 && LRI_finished == 1 && AVI_finished == 1 && VRP_finished == 1 && RHM_finished == 1 && PVARP_finished == 1 && URI_finished == 1) ->
        d_step{
            RSA_finished == 0; LRI_finished == 0; AVI_finished == 0; VRP_finished == 0; RHM_finished == 0; PVARP_finished == 0; URI_finished == 0; 
            AP = LRI_AP;
            VP = AVI_VP;
            AS = PVARP_AS;
            VS = VRP_VS;
            time = AVI_t;
            AEI = LRI_AEI;
            pacing_rate = LRI_t;
            toggle_value = RSA_toggle;
            value_value = RSA_value;
            clock = URI_clk;

            // ADD ASSERT STATEMENT CHECK HERE
            //if
            //:: (pre_x < y) -> assert(false)
            //:: else -> skip
            //fi
            pre_AP = AP;
            pre_VP = VP;
            pre_AS = AS;
            pre_VS = VS;
            pre_time = time;
            pre_inspiration = inspiration;
            pre_AEI = AEI;
            pre_pacing_rate = pacing_rate;
            pre_toggle_value = toggle_value;
            pre_value_value = value_value;
            pre_clock = clock;

            AP = 0;
            VP = 0;
            AS = 0;
            VS = 0;
            time = 0;
            inspiration = 0;
            AEI = 0;
            pacing_rate = 0;
            toggle_value = 0;
            value_value = 0;
            clock = 0;

    }
}

proctype RSA_model(){

    INS_init:  RSA_finished == 0 ->
        if
        ::(pre_AP) RSA_value = 0; RSA_toggle = true; RSA_t = 0; RSA_finished == 1; goto INS_trim;
        ::(RSA_INS == 0) RSA_value = 2; RSA_toggle = true; RSA_t = 0; RSA_finished == 1; goto INS_EXP;
        ::else -> RSA_finished == 1; goto INS_init;
        fi

    INS_trim:  RSA_finished == 0 ->
        if
        ::(pre_AP) RSA_value = 0; RSA_toggle = true; RSA_t = 0; RSA_finished == 1; goto INS_trim;
        ::(RSA_INS == 0) RSA_value = 2; RSA_toggle = true; RSA_t = 0; RSA_finished == 1; goto INS_EXP;
        ::else -> RSA_finished == 1; goto INS_trim;
        fi

    EXP_init:  RSA_finished == 0 ->
        if
        ::(pre_AP) RSA_value = 0; RSA_toggle = true; RSA_t = 0; RSA_finished == 1; goto EXP_trim;
        ::(RSA_INS) RSA_value = 1; RSA_toggle = true; RSA_t = 0; RSA_finished == 1; goto EXP_INS;
        ::else -> RSA_finished == 1; goto EXP_init;
        fi

    EXP_trim:  RSA_finished == 0 ->
        if
        ::(pre_AP) RSA_value = 0; RSA_toggle = true; RSA_t = 0; RSA_finished == 1; goto EXP_trim;
        ::(RSA_INS) RSA_value = 1; RSA_toggle = true; RSA_t = 0; RSA_finished == 1; goto EXP_INS;
        ::else -> RSA_finished == 1; goto EXP_trim;
        fi

    INS_EXP:  RSA_finished == 0 ->
        if
        ::(RSA_INS) RSA_value = 0; RSA_toggle = true; RSA_t = 0; RSA_finished == 1; goto INS_init;
        ::(pre_AP) RSA_value = 0; RSA_toggle = true; RSA_t = 0; RSA_finished == 1; goto EXP_init;
        ::else -> RSA_finished == 1; goto INS_EXP;
        fi

    EXP_INS:  RSA_finished == 0 ->
        if
        ::(RSA_INS == 0) RSA_value = 0; RSA_toggle = true; RSA_t = 0; RSA_finished == 1; goto EXP_init;
        ::(pre_AP) RSA_value = 0; RSA_toggle = true; RSA_t = 0; RSA_finished == 1; goto INS_init;
        ::else -> RSA_finished == 1; goto EXP_INS;
        fi

}


proctype LRI_model(){

    LRI:  LRI_finished == 0 ->
        if
        ::(pre_AS && LRI_toggle == 0) LRI_finished == 1; goto ASED;
        ::(pre_AS && LRI_toggle) LRI_AEI = rsa(LRI_value, LRI_current_AEI); LRI_AP = false; LRI_finished == 1; goto ASED;
        ::(pre_VS || pre_VP) LRI_t = 0; LRI_finished == 1; goto LRI;
        ::(LRI_toggle) LRI_AEI = rsa(LRI_value, LRI_current_AEI); LRI_AP = false; LRI_finished == 1; goto LRI;
        ::(LRI_t >= pre_AEI) LRI_t = 0; LRI_AP = true; LRI_finished == 1; goto LRI;
        ::else -> LRI_finished == 1; goto LRI;
        fi

    ASED:  LRI_finished == 0 ->
        if
        ::(pre_VS || pre_VP) LRI_t = 0; LRI_finished == 1; goto LRI;
        ::(LRI_toggle) LRI_AEI = rsa(LRI_value, LRI_current_AEI); LRI_AP = false; LRI_finished == 1; goto ASED;
        ::else -> LRI_finished == 1; goto ASED;
        fi

}


proctype AVI_model(){

    IDLE:  AVI_finished == 0 ->
        if
        ::(pre_AS || pre_AP) AVI_VP = false; AVI_t = 0; AVI_finished == 1; goto AVI;
        ::else -> AVI_finished == 1; goto IDLE;
        fi

    AVI:  AVI_finished == 0 ->
        if
        ::(pre_VS) AVI_finished == 1; goto IDLE;
        ::(AVI_clk >= AVI_TURI && AVI_t >= AVI_TAVI) AVI_VP = true; AVI_finished == 1; goto IDLE;
        ::(AVI_clk < AVI_TURI && AVI_t >= AVI_TAVI) AVI_finished == 1; goto WAIT;
        ::else -> AVI_finished == 1; goto AVI;
        fi

    WAIT:  AVI_finished == 0 ->
        if
        ::(pre_VS) AVI_finished == 1; goto IDLE;
        ::(pre_VS == 0 && AVI_clk >= AVI_TURI) AVI_VP = true; AVI_finished == 1; goto IDLE;
        ::else -> AVI_finished == 1; goto WAIT;
        fi

}


proctype VRP_model(){

    IDLE:  VRP_finished == 0 ->
        if
        ::(pre_VP) VRP_t = 0; VRP_finished == 1; goto VRP;
        ::(VRP_Vget) VRP_t = 0; VRP_VS = true; VRP_finished == 1; goto VRP;
        ::else -> VRP_finished == 1; goto IDLE;
        fi

    VRP:  VRP_finished == 0 ->
        if
        ::(VRP_t >= VRP_TVRP) VRP_finished == 1; goto IDLE;
        ::else -> VRP_finished == 1; goto VRP;
        fi

}


proctype RHM_model(){

    R1:  RHM_finished == 0 ->
        if
        ::(RHM_t == RHM_TAV) RHM_t = 0; RHM_Aget = false; RHM_Vget = true; RHM_finished == 1; goto R2;
        ::(pre_VP) RHM_t = 0; RHM_finished == 1; goto R2;
        ::(pre_AP) RHM_t = 0; RHM_finished == 1; goto R1;
        ::else -> RHM_finished == 1; goto R1;
        fi

    R2:  RHM_finished == 0 ->
        if
        ::(RHM_t == RHM_TVA) RHM_t = 0; RHM_Aget = true; RHM_Vget = false; RHM_finished == 1; goto R1;
        ::(pre_AP) RHM_t = 0; RHM_finished == 1; goto R1;
        ::(pre_VP) RHM_t = 0; RHM_finished == 1; goto R2;
        ::else -> RHM_finished == 1; goto R2;
        fi

}


proctype PVARP_model(){

    IDLE:  PVARP_finished == 0 ->
        if
        ::(pre_VS || pre_VP) PVARP_t = 0; PVARP_finished == 1; goto PVAB;
        ::(PVARP_Aget && (pre_VS || pre_VP)) PVARP_t = 0; PVARP_AS = true; PVARP_finished == 1; goto PVAB;
        ::else -> PVARP_finished == 1; goto IDLE;
        fi

    PVAB:  PVARP_finished == 0 ->
        if
        ::(PVARP_t >= PVARP_TPVAB) PVARP_finished == 1; goto PVARP;
        ::else -> PVARP_finished == 1; goto PVAB;
        fi

    PVARP:  PVARP_finished == 0 ->
        if
        ::(PVARP_Aget && PVARP_t < PVARP_TPVARP) PVARP_AS = false; PVARP_AR = true; PVARP_finished == 1; goto PVARP;
        ::(PVARP_Aget && PVARP_t >= PVARP_TPVARP) PVARP_t = 0; PVARP_AR = true; PVARP_finished == 1; goto IDLE;
        ::(PVARP_t >= PVARP_TPVARP) PVARP_t = 0; PVARP_finished == 1; goto IDLE;
        ::else -> PVARP_finished == 1; goto PVARP;
        fi

}


proctype URI_model(){

    URI:  URI_finished == 0 ->
        if
        ::(pre_VS || pre_VP) URI_clk = 0; URI_finished == 1; goto URI;
        ::else -> URI_finished == 1; goto URI;
        fi

}