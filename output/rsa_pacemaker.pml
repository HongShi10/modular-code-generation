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
bool RSA_APED = 0;
bool RSA_INSED = 0;
int RSA_t = 0;

// LRI Variables without mappings
bool LRI_INS = 0;

// AVI Variables without mappings
int AVI_TURI = 0;
int AVI_TAVI = 0;

// VRP Variables without mappings
int VRP_TVRP = 0;
int VRP_t = 0;

// RHM Variables without mappings
bool RHM_Aget = 0;
bool RHM_Vget = 0;
int RHM_TAV = 0;
int RHM_TVA = 0;
int RHM_t = 0;

// PVARP Variables without mappings
bool PVARP_AR = 0;
int PVARP_TPVAB = 0;
int PVARP_TPVARP = 0;
int PVARP_t = 0;

// URI Variables without mappings

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
        ::(pre_AP) -> value_value = (0); toggle_value = (true); RSA_t = (0);  RSA_finished = 1; goto INS_trim;
        ::(RSA_INS == 0) -> value_value = (20000); toggle_value = (true); RSA_t = (0);  RSA_finished = 1; goto INS_EXP;
        ::((pre_AP || RSA_INS == 0) == 0) -> toggle_value = (false); RSA_t = (10000) * 10 / 10000 + RSA_t; RSA_finished = 1; goto INS_init
        fi;

    INS_trim:  (RSA_finished == 0) -> 
        if
        ::(pre_AP) -> value_value = (0); toggle_value = (true); RSA_t = (0);  RSA_finished = 1; goto INS_trim;
        ::(RSA_INS == 0) -> value_value = (20000); toggle_value = (true); RSA_t = (0);  RSA_finished = 1; goto INS_EXP;
        ::((pre_AP || RSA_INS == 0) == 0) -> toggle_value = (false); RSA_t = (10000) * 10 / 10000 + RSA_t; RSA_finished = 1; goto INS_trim
        fi;

    EXP_init:  (RSA_finished == 0) -> 
        if
        ::(pre_AP) -> value_value = (0); toggle_value = (true); RSA_t = (0);  RSA_finished = 1; goto EXP_trim;
        ::(RSA_INS) -> value_value = (10000); toggle_value = (true); RSA_t = (0);  RSA_finished = 1; goto EXP_INS;
        ::((pre_AP || RSA_INS) == 0) -> toggle_value = (false); RSA_t = (10000) * 10 / 10000 + RSA_t; RSA_finished = 1; goto EXP_init
        fi;

    EXP_trim:  (RSA_finished == 0) -> 
        if
        ::(pre_AP) -> value_value = (0); toggle_value = (true); RSA_t = (0);  RSA_finished = 1; goto EXP_trim;
        ::(RSA_INS) -> value_value = (10000); toggle_value = (true); RSA_t = (0);  RSA_finished = 1; goto EXP_INS;
        ::((pre_AP || RSA_INS) == 0) -> toggle_value = (false); RSA_t = (10000) * 10 / 10000 + RSA_t; RSA_finished = 1; goto EXP_trim
        fi;

    INS_EXP:  (RSA_finished == 0) -> 
        if
        ::(RSA_INS) -> value_value = (0); toggle_value = (true); RSA_t = (0);  RSA_finished = 1; goto INS_init;
        ::(pre_AP) -> value_value = (0); toggle_value = (true); RSA_t = (0);  RSA_finished = 1; goto EXP_init;
        ::((RSA_INS || pre_AP) == 0) -> toggle_value = (false); RSA_t = (10000) * 10 / 10000 + RSA_t; RSA_finished = 1; goto INS_EXP
        fi;

    EXP_INS:  (RSA_finished == 0) -> 
        if
        ::(RSA_INS == 0) -> value_value = (0); toggle_value = (true); RSA_t = (0);  RSA_finished = 1; goto EXP_init;
        ::(pre_AP) -> value_value = (0); toggle_value = (true); RSA_t = (0);  RSA_finished = 1; goto INS_init;
        ::((RSA_INS == 0 || pre_AP) == 0) -> toggle_value = (false); RSA_t = (10000) * 10 / 10000 + RSA_t; RSA_finished = 1; goto EXP_INS
        fi;

}


proctype LRI_model(){

    LRI:  (LRI_finished == 0) -> 
        if
        ::(pre_AS && pre_toggle_value == 0) ->  LRI_finished = 1; goto ASED;
        ::(pre_AS && pre_toggle_value) ->  atomic{ run rsa(pre_value_value, pre_AEI);  AEI = LRI_rsa_function_returnVar} ; AP = (false);  LRI_finished = 1; goto ASED;
        ::(pre_VS || pre_VP) -> pacing_rate = (0);  LRI_finished = 1; goto LRI;
        ::(pre_toggle_value) ->  atomic{ run rsa(pre_value_value, pre_AEI);  AEI = LRI_rsa_function_returnVar} ; AP = (false);  LRI_finished = 1; goto LRI;
        ::(pre_pacing_rate >= pre_AEI) -> pacing_rate = (0); AP = (true);  LRI_finished = 1; goto LRI;
        ::(((pre_AS && pre_toggle_value == 0) || (pre_AS && pre_toggle_value) || pre_VS || pre_VP || pre_toggle_value || pre_pacing_rate >= pre_AEI) == 0) -> AP = (false); AEI = (pre_AEI); pacing_rate = (10000) * 10 / 10000 + pre_pacing_rate; LRI_finished = 1; goto LRI
        fi;

    ASED:  (LRI_finished == 0) -> 
        if
        ::(pre_VS || pre_VP) -> pacing_rate = (0);  LRI_finished = 1; goto LRI;
        ::(pre_toggle_value) ->  atomic{ run rsa(pre_value_value, pre_AEI);  AEI = LRI_rsa_function_returnVar} ; AP = (false);  LRI_finished = 1; goto ASED;
        ::((pre_VS || pre_VP || pre_toggle_value) == 0) -> AP = (false); AEI = (pre_AEI); pacing_rate = (10000) * 10 / 10000 + pre_pacing_rate; LRI_finished = 1; goto ASED
        fi;

}


proctype AVI_model(){

    IDLE:  (AVI_finished == 0) -> 
        if
        ::(pre_AS || pre_AP) -> VP = (false); time = (0);  AVI_finished = 1; goto AVI;
        ::((pre_AS || pre_AP) == 0) -> VP = (false); time = (10000) * 10 / 10000 + pre_time; AVI_finished = 1; goto IDLE
        fi;

    AVI:  (AVI_finished == 0) -> 
        if
        ::(pre_VS) ->  AVI_finished = 1; goto IDLE;
        ::(pre_clock >= AVI_TURI && pre_time >= AVI_TAVI) -> VP = (true);  AVI_finished = 1; goto IDLE;
        ::(pre_clock < AVI_TURI && pre_time >= AVI_TAVI) ->  AVI_finished = 1; goto WAIT;
        ::((pre_VS || (pre_clock >= AVI_TURI && pre_time >= AVI_TAVI) || (pre_clock < AVI_TURI && pre_time >= AVI_TAVI)) == 0) -> VP = (false); time = (10000) * 10 / 10000 + pre_time; AVI_finished = 1; goto AVI
        fi;

    WAIT:  (AVI_finished == 0) -> 
        if
        ::(pre_VS) ->  AVI_finished = 1; goto IDLE;
        ::(pre_VS == 0 && pre_clock >= AVI_TURI) -> VP = (true);  AVI_finished = 1; goto IDLE;
        ::((pre_VS || (pre_VS == 0 && pre_clock >= AVI_TURI)) == 0) -> VP = (false); time = (10000) * 10 / 10000 + pre_time; AVI_finished = 1; goto WAIT
        fi;

}


proctype VRP_model(){

    IDLE:  (VRP_finished == 0) -> 
        if
        ::(pre_VP) -> VRP_t = (0);  VRP_finished = 1; goto VRP;
        ::(RHM_Vget) -> VRP_t = (0); VS = (true);  VRP_finished = 1; goto VRP;
        ::(RHM_Vget == 0 && pre_VP == 0) -> VS = (false); VRP_t = (0) * 10 / 10000 + VRP_t; VRP_finished = 1; goto IDLE
        fi;

    VRP:  (VRP_finished == 0) -> 
        if
        ::(VRP_t >= VRP_TVRP) ->  VRP_finished = 1; goto IDLE;
        ::(VRP_t < VRP_TVRP) -> VS = (false); VRP_t = (10000) * 10 / 10000 + VRP_t; VRP_finished = 1; goto VRP
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
        ::(RHM_Aget && (pre_VS || pre_VP)) -> PVARP_t = (0); AS = (true);  PVARP_finished = 1; goto PVAB;
        ::(pre_VS == 0 && pre_VP == 0) -> AS = (false); PVARP_AR = (false); PVARP_t = (0) * 10 / 10000 + PVARP_t; PVARP_finished = 1; goto IDLE
        fi;

    PVAB:  (PVARP_finished == 0) -> 
        if
        ::(PVARP_t >= PVARP_TPVAB) ->  PVARP_finished = 1; goto PVARP;
        ::(PVARP_t < PVARP_TPVAB) -> AS = (false); PVARP_AR = (false); PVARP_t = (10000) * 10 / 10000 + PVARP_t; PVARP_finished = 1; goto PVAB
        fi;

    PVARP:  (PVARP_finished == 0) -> 
        if
        ::(RHM_Aget && PVARP_t < PVARP_TPVARP) -> AS = (false); PVARP_AR = (true);  PVARP_finished = 1; goto PVARP;
        ::(RHM_Aget && PVARP_t >= PVARP_TPVARP) -> PVARP_t = (0); PVARP_AR = (true);  PVARP_finished = 1; goto IDLE;
        ::(PVARP_t >= PVARP_TPVARP) -> PVARP_t = (0);  PVARP_finished = 1; goto IDLE;
        ::(RHM_Aget == 0 || PVARP_t < PVARP_TPVARP) -> AS = (false); PVARP_AR = (false); PVARP_t = (10000) * 10 / 10000 + PVARP_t; PVARP_finished = 1; goto PVARP
        fi;

}


proctype URI_model(){

    URI:  (URI_finished == 0) -> 
        if
        ::(pre_VS || pre_VP) -> clock = (0);  URI_finished = 1; goto URI;
        ::(pre_VP == 0 && pre_VS == 0) -> clock = (10000) * 10 / 10000 + pre_clock; URI_finished = 1; goto URI
        fi;

}
proctype LRI_rsa(int value; int current_AEI){
    if 
    ::(value == 0) -> 
        LRI_rsa_function_returnVar = 4020; 
    ::(value == 10000) -> 
        LRI_rsa_function_returnVar = 3570;
    ::(value == 20000) -> 
        LRI_rsa_function_returnVar = 4570;
    ::(value == 30000) -> 
        if 
        ::(current_AEI > 3460) -> 
            LRI_rsa_function_returnVar = current_AEI - 100; 
        ::else -> 
            LRI_rsa_function_returnVar = 3370;
        fi
    ::(value == 40000) -> 
        if 
        ::(current_AEI < 4680) -> 
            LRI_rsa_function_returnVar = current_AEI + 100; 
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