int global_tick = 0
// Global Variables 
bool AP = 0;
bool VP = 0;
bool AS = 0;
bool VS = 0;
int time = 0;
bool inspiration = 0;
int AEI = 0;
int pacing_rate = 0;
int toggle_value = 0;
int value_value = 0;
int clock = 0;
int asdasd = 0;


// RSA Variables without mappings
bool RSA_INS = 0;
int RSA_value = 0;
bool RSA_toggle = 0;
bool RSA_APED = 0;
bool RSA_INSED = 0;
int RSA_t = 0;

// LRI Variables without mappings
bool LRI_INS = 0;
bool LRI_AP = 0;
int LRI_AEI = 0;
int LRI_t = 0;

// AVI Variables without mappings
bool AVI_VP = 0;
int AVI_t = 0;
int AVI_TURI = 0;
int AVI_TAVI = 0;

// VRP Variables without mappings
bool VRP_VS = 0;
int VRP_TVRP = 0;
int VRP_t = 0;

// RHM Variables without mappings
bool RHM_Aget = 0;
bool RHM_Vget = 0;
int RHM_TAV = 0;
int RHM_TVA = 0;
int RHM_t = 0;

// PVARP Variables without mappings
bool PVARP_AS = 0;
bool PVARP_AR = 0;
int PVARP_TPVAB = 0;
int PVARP_TPVARP = 0;
int PVARP_t = 0;

// URI Variables without mappings
int URI_clk = 0;

bool pre_AP = 0;
bool pre_VP = 0;
bool pre_AS = 0;
bool pre_VS = 0;
int pre_time = 0;
bool pre_inspiration = 0;
int pre_AEI = 0;
int pre_pacing_rate = 0;
int pre_toggle_value = 0;
int pre_value_value = 0;
int pre_clock = 0;

bit RSA_finished = 0;
bit LRI_finished = 0;
bit AVI_finished = 0;
bit VRP_finished = 0;
bit RHM_finished = 0;
bit PVARP_finished = 0;
bit URI_finished = 0;

int LRI_rsa_function_returnVar = 0;



proctype clock_pro(){

    INITIAL:
        if
        ::(global_tick == 1200000) -> skip;
        ::(RSA_finished == 1 && LRI_finished == 1 && AVI_finished == 1 && VRP_finished == 1 && RHM_finished == 1 && PVARP_finished == 1 && URI_finished == 1) ->
            d_step{
                global_tick++
                RSA_finished = 0; LRI_finished = 0; AVI_finished = 0; VRP_finished = 0; RHM_finished = 0; PVARP_finished = 0; URI_finished = 0; 
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
            }
        goto INITIAL;
        fi;
}

proctype RSA_model(){

    INS_init:  (RSA_finished == 0) -> 
        if
        ::(pre_AP) -> RSA_value = (0); RSA_toggle = (true); RSA_t = (0);  RSA_finished = 1; goto INS_trim;
        ::(RSA_INS == 0) -> RSA_value = (20000); RSA_toggle = (true); RSA_t = (0);  RSA_finished = 1; goto INS_EXP;
        ::((pre_AP || RSA_INS == 0) == 0) -> RSA_toggle = (false); RSA_t = (10000) * 10 / 10000 + RSA_t; RSA_finished = 1; goto INS_init
        fi;

    INS_trim:  (RSA_finished == 0) -> 
        if
        ::(pre_AP) -> RSA_value = (0); RSA_toggle = (true); RSA_t = (0);  RSA_finished = 1; goto INS_trim;
        ::(RSA_INS == 0) -> RSA_value = (20000); RSA_toggle = (true); RSA_t = (0);  RSA_finished = 1; goto INS_EXP;
        ::((pre_AP || RSA_INS == 0) == 0) -> RSA_toggle = (false); RSA_t = (10000) * 10 / 10000 + RSA_t; RSA_finished = 1; goto INS_trim
        fi;

    EXP_init:  (RSA_finished == 0) -> 
        if
        ::(pre_AP) -> RSA_value = (0); RSA_toggle = (true); RSA_t = (0);  RSA_finished = 1; goto EXP_trim;
        ::(RSA_INS) -> RSA_value = (10000); RSA_toggle = (true); RSA_t = (0);  RSA_finished = 1; goto EXP_INS;
        ::((pre_AP || RSA_INS) == 0) -> RSA_toggle = (false); RSA_t = (10000) * 10 / 10000 + RSA_t; RSA_finished = 1; goto EXP_init
        fi;

    EXP_trim:  (RSA_finished == 0) -> 
        if
        ::(pre_AP) -> RSA_value = (0); RSA_toggle = (true); RSA_t = (0);  RSA_finished = 1; goto EXP_trim;
        ::(RSA_INS) -> RSA_value = (10000); RSA_toggle = (true); RSA_t = (0);  RSA_finished = 1; goto EXP_INS;
        ::((pre_AP || RSA_INS) == 0) -> RSA_toggle = (false); RSA_t = (10000) * 10 / 10000 + RSA_t; RSA_finished = 1; goto EXP_trim
        fi;

    INS_EXP:  (RSA_finished == 0) -> 
        if
        ::(RSA_INS) -> RSA_value = (0); RSA_toggle = (true); RSA_t = (0);  RSA_finished = 1; goto INS_init;
        ::(pre_AP) -> RSA_value = (0); RSA_toggle = (true); RSA_t = (0);  RSA_finished = 1; goto EXP_init;
        ::((RSA_INS || pre_AP) == 0) -> RSA_toggle = (false); RSA_t = (10000) * 10 / 10000 + RSA_t; RSA_finished = 1; goto INS_EXP
        fi;

    EXP_INS:  (RSA_finished == 0) -> 
        if
        ::(RSA_INS == 0) -> RSA_value = (0); RSA_toggle = (true); RSA_t = (0);  RSA_finished = 1; goto EXP_init;
        ::(pre_AP) -> RSA_value = (0); RSA_toggle = (true); RSA_t = (0);  RSA_finished = 1; goto INS_init;
        ::((RSA_INS == 0 || pre_AP) == 0) -> RSA_toggle = (false); RSA_t = (10000) * 10 / 10000 + RSA_t; RSA_finished = 1; goto EXP_INS
        fi;

}


proctype LRI_model(){

    LRI:  (LRI_finished == 0) -> 
        if
        ::(pre_AS && LRI_toggle == 0) ->  LRI_finished = 1; goto ASED;
        ::(pre_AS && LRI_toggle) ->  atomic{ run rsa(LRI_value, LRI_current_AEI);  LRI_AEI =  LRI_rsa_function_returnVar} ; LRI_AP = (false);  LRI_finished = 1; goto ASED;
        ::(pre_VS || pre_VP) -> LRI_t = (0);  LRI_finished = 1; goto LRI;
        ::(LRI_toggle) ->  atomic{ run rsa(LRI_value, LRI_current_AEI);  LRI_AEI =  LRI_rsa_function_returnVar} ; LRI_AP = (false);  LRI_finished = 1; goto LRI;
        ::(LRI_t >= pre_AEI) -> LRI_t = (0); LRI_AP = (true);  LRI_finished = 1; goto LRI;
        ::(((pre_AS && LRI_toggle == 0) || (pre_AS && LRI_toggle) || pre_VS || pre_VP || LRI_toggle || LRI_t >= pre_AEI) == 0) -> LRI_AP = (false); LRI_AEI = (pre_AEI); LRI_t = (10000) * 10 / 10000 + LRI_t; LRI_finished = 1; goto LRI
        fi;

    ASED:  (LRI_finished == 0) -> 
        if
        ::(pre_VS || pre_VP) -> LRI_t = (0);  LRI_finished = 1; goto LRI;
        ::(LRI_toggle) ->  atomic{ run rsa(LRI_value, LRI_current_AEI);  LRI_AEI =  LRI_rsa_function_returnVar} ; LRI_AP = (false);  LRI_finished = 1; goto ASED;
        ::((pre_VS || pre_VP || LRI_toggle) == 0) -> LRI_AP = (false); LRI_AEI = (pre_AEI); LRI_t = (10000) * 10 / 10000 + LRI_t; LRI_finished = 1; goto ASED
        fi;

}


proctype AVI_model(){

    IDLE:  (AVI_finished == 0) -> 
        if
        ::(pre_AS || pre_AP) -> AVI_VP = (false); AVI_t = (0);  AVI_finished = 1; goto AVI;
        ::((pre_AS || pre_AP) == 0) -> AVI_VP = (false); AVI_t = (10000) * 10 / 10000 + AVI_t; AVI_finished = 1; goto IDLE
        fi;

    AVI:  (AVI_finished == 0) -> 
        if
        ::(pre_VS) ->  AVI_finished = 1; goto IDLE;
        ::(AVI_clk >= AVI_TURI && AVI_t >= AVI_TAVI) -> AVI_VP = (true);  AVI_finished = 1; goto IDLE;
        ::(AVI_clk < AVI_TURI && AVI_t >= AVI_TAVI) ->  AVI_finished = 1; goto WAIT;
        ::((pre_VS || (AVI_clk >= AVI_TURI && AVI_t >= AVI_TAVI) || (AVI_clk < AVI_TURI && AVI_t >= AVI_TAVI)) == 0) -> AVI_VP = (false); AVI_t = (10000) * 10 / 10000 + AVI_t; AVI_finished = 1; goto AVI
        fi;

    WAIT:  (AVI_finished == 0) -> 
        if
        ::(pre_VS) ->  AVI_finished = 1; goto IDLE;
        ::(pre_VS == 0 && AVI_clk >= AVI_TURI) -> AVI_VP = (true);  AVI_finished = 1; goto IDLE;
        ::((pre_VS || (pre_VS == 0 && AVI_clk >= AVI_TURI)) == 0) -> AVI_VP = (false); AVI_t = (10000) * 10 / 10000 + AVI_t; AVI_finished = 1; goto WAIT
        fi;

}


proctype VRP_model(){

    IDLE:  (VRP_finished == 0) -> 
        if
        ::(pre_VP) -> VRP_t = (0);  VRP_finished = 1; goto VRP;
        ::(VRP_Vget) -> VRP_t = (0); VRP_VS = (true);  VRP_finished = 1; goto VRP;
        ::(VRP_Vget == 0 && pre_VP == 0) -> VRP_VS = (false); VRP_t = (0) * 10 / 10000 + VRP_t; VRP_finished = 1; goto IDLE
        fi;

    VRP:  (VRP_finished == 0) -> 
        if
        ::(VRP_t >= VRP_TVRP) ->  VRP_finished = 1; goto IDLE;
        ::(VRP_t < VRP_TVRP) -> VRP_VS = (false); VRP_t = (10000) * 10 / 10000 + VRP_t; VRP_finished = 1; goto VRP
        fi;

}


proctype RHM_model(){

    R1:  (RHM_finished == 0) -> 
        if
        ::(RHM_t == RHM_TAV) -> RHM_t = (0); RHM_Aget = (false); RHM_Vget = (true);  RHM_finished = 1; goto R2;
        ::(pre_VP) -> RHM_t = (0);  RHM_finished = 1; goto R2;
        ::(pre_AP) -> RHM_t = (0);  RHM_finished = 1; goto R1;
        ::(RHM_t < RHM_TAV && pre_VP == 0 && pre_AP == 0) -> RHM_Aget = (false); RHM_Vget = (false); RHM_t = (10000) * 10 / 10000 + RHM_t; RHM_finished = 1; goto R1
        fi;

    R2:  (RHM_finished == 0) -> 
        if
        ::(RHM_t == RHM_TVA) -> RHM_t = (0); RHM_Aget = (true); RHM_Vget = (false);  RHM_finished = 1; goto R1;
        ::(pre_AP) -> RHM_t = (0);  RHM_finished = 1; goto R1;
        ::(pre_VP) -> RHM_t = (0);  RHM_finished = 1; goto R2;
        ::(RHM_t < RHM_TVA && pre_AP == 0 && pre_VP == 0) -> RHM_Aget = (false); RHM_Vget = (false); RHM_t = (10000) * 10 / 10000 + RHM_t; RHM_finished = 1; goto R2
        fi;

}


proctype PVARP_model(){

    IDLE:  (PVARP_finished == 0) -> 
        if
        ::(pre_VS || pre_VP) -> PVARP_t = (0);  PVARP_finished = 1; goto PVAB;
        ::(PVARP_Aget && (pre_VS || pre_VP)) -> PVARP_t = (0); PVARP_AS = (true);  PVARP_finished = 1; goto PVAB;
        ::(pre_VS == 0 && pre_VP == 0) -> PVARP_AS = (false); PVARP_AR = (false); PVARP_t = (0) * 10 / 10000 + PVARP_t; PVARP_finished = 1; goto IDLE
        fi;

    PVAB:  (PVARP_finished == 0) -> 
        if
        ::(PVARP_t >= PVARP_TPVAB) ->  PVARP_finished = 1; goto PVARP;
        ::(PVARP_t < PVARP_TPVAB) -> PVARP_AS = (false); PVARP_AR = (false); PVARP_t = (10000) * 10 / 10000 + PVARP_t; PVARP_finished = 1; goto PVAB
        fi;

    PVARP:  (PVARP_finished == 0) -> 
        if
        ::(PVARP_Aget && PVARP_t < PVARP_TPVARP) -> PVARP_AS = (false); PVARP_AR = (true);  PVARP_finished = 1; goto PVARP;
        ::(PVARP_Aget && PVARP_t >= PVARP_TPVARP) -> PVARP_t = (0); PVARP_AR = (true);  PVARP_finished = 1; goto IDLE;
        ::(PVARP_t >= PVARP_TPVARP) -> PVARP_t = (0);  PVARP_finished = 1; goto IDLE;
        ::(PVARP_Aget == 0 || PVARP_t < PVARP_TPVARP) -> PVARP_AS = (false); PVARP_AR = (false); PVARP_t = (10000) * 10 / 10000 + PVARP_t; PVARP_finished = 1; goto PVARP
        fi;

}


proctype URI_model(){

    URI:  (URI_finished == 0) -> 
        if
        ::(pre_VS || pre_VP) -> URI_clk = (0);  URI_finished = 1; goto URI;
        ::(pre_VP == 0 && pre_VS == 0) -> URI_clk = (10000) * 10 / 10000 + URI_clk; URI_finished = 1; goto URI
        fi;

}
proctype LRI_rsa(int value, int current_AEI){
    if 
    ::( == 0) -> 
        LRI_rsa_function_returnVar = 4020; 
    ::( == 10000) -> 
        LRI_rsa_function_returnVar = 3570;
    ::( == 20000) -> 
        LRI_rsa_function_returnVar = 4570;
    ::( == 30000) -> 
        if 
        ::( > 3460) -> 
            LRI_rsa_function_returnVar =  - 100; 
        ::else -> 
            LRI_rsa_function_returnVar = 3370;
        fi
    ::( == 40000) -> 
        if 
        ::( < 4680) -> 
            LRI_rsa_function_returnVar =  + 100; 
        ::else -> 
            LRI_rsa_function_returnVar = 4770;
        fi
    ::else -> 
        LRI_rsa_function_returnVar = 4020;
    fi
}init {
    atomic {
         run RSA_model();
         run LRI_model();
         run AVI_model();
         run VRP_model();
         run RHM_model();
         run PVARP_model();
         run URI_model();
         run clock_pro();
    }
}