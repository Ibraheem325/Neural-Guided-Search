"""Shared arm/probe/baseline configuration for the five domains.

Extracted so table_plan_len.py and table_by_base.py cannot drift apart -- they must report
the same arms over the same probe sets, or the per-probe and per-base-problem views of the
same sweep stop being comparable.

Each entry: base results dir, probe dir, FD optimal-length json, and the tables (label ->
results dir) in the order they should print.
"""

DOMAINS = {
    "goldminer": dict(
        # Rebuilt on the distinct probe set (2026-08-11). The old set --
        # probeGold_near_goal_d5-20 -- drew 480 probes from only 30 source problems, and
        # 64 of them came from VAL, the split used for checkpoint selection.
        # eps=0.26 is goldminer's OWN matched mass (W=0.258 at beta=1, refit on these
        # probes); the old config said 0.28.
        # CAUTION: median branching is 2, so shuffle degenerates and the random control
        # fails its fit diagnostic. The flat arms are the only clean control here.
        base="gm_base",
        probe="example/probeGold_distinct_d5-22",
        optlen="optlen_goldminer_distinct.json",
        tables=[
            ("ADDITIVE", [
                ("beta=1 kappa=1",         "gm_abs_t1b1k1"),
                ("beta=1 kappa=0 (prior)", "gm_abs_t1b1k0"),
                ("beta=2 kappa=1",         "gm_abs_t1b2k1"),
                ("beta=0 kappa=1 (c(s))",  "gm_abs_t1b0k1"),
                ("shuffle",                "gm_abs_t1b1k1_shuf"),
                ("random",                 "gm_abs_t1b1k1_rndm"),
            ]),
            ("MULTIPLICATIVE", [
                ("eps=0.001 kappa=0",      "gm_mul_e001_k0"),
                ("eps=0.001 kappa=1",      "gm_mul_e001_k1"),
                ("eps=0.26 kappa=0",       "gm_mul_e026_k0"),
                ("eps=0.40 kappa=0",       "gm_mul_e040_k0"),
                ("eps=0.40 shuffle",       "gm_mul_e040_k0_shuf"),
                ("eps=0.60 kappa=0",       "gm_mul_e060_k0"),
                ("eps=0.26 shuffle",       "gm_mul_e026_k0_shuf"),
            ]),
        ]),
    "satellite": dict(
        base="sat_base",
        probe="example/probeSat_distinct_d5-22",
        optlen="optlen_satellite_distinct.json",
        tables=[
            ("ADDITIVE", [
                ("beta=1 kappa=1",         "sat_abs_t1b1k1"),
                ("beta=1 kappa=0 (prior)", "sat_abs_t1b1k0"),
                ("beta=2 kappa=1",         "sat_abs_t1b2k1"),
                ("beta=0 kappa=1 (c(s))",  "sat_abs_t1b0k1"),
                ("shuffle",                "sat_abs_t1b1k1_shuf"),
                ("random",                 "sat_abs_t1b1k1_rndm"),
            ]),
            # eps=0.25 is satellite's OWN matched mass (W=0.247 at beta=1), the analogue of
            # grid 0.27 / goldminer 0.28 / logistics 0.29.
            ("MULTIPLICATIVE", [
                ("eps=0.001 kappa=0",      "sat_mul_e001_k0"),
                ("eps=0.001 kappa=1",      "sat_mul_e001_k1"),
                ("eps=0.25 kappa=0",       "sat_mul_e025_k0"),
                ("eps=0.25 shuffle",       "sat_mul_e025_k0_shuf"),
                ("eps=0.40 kappa=0",       "sat_mul_e040_k0"),
                ("eps=0.40 shuffle",       "sat_mul_e040_k0_shuf"),
                ("eps=0.60 kappa=0",       "sat_mul_e060_k0"),
            ]),
        ]),
    "rovers": dict(
        base="rov_base",
        probe="example/probeRov_distinct_d5-22",
        optlen="optlen_rovers_distinct.json",
        tables=[
            ("ADDITIVE", [
                ("beta=1 kappa=1",         "rov_abs_t1b1k1"),
                ("beta=1 kappa=0 (prior)", "rov_abs_t1b1k0"),
                ("beta=2 kappa=1",         "rov_abs_t1b2k1"),
                ("beta=0 kappa=1 (c(s))",  "rov_abs_t1b0k1"),
                ("shuffle",                "rov_abs_t1b1k1_shuf"),
                ("random",                 "rov_abs_t1b1k1_rndm"),
            ]),
            # eps=0.27 is rovers' OWN matched mass (W=0.274 at beta=1, distinct TEST probes).
            ("MULTIPLICATIVE", [
                ("eps=0.001 kappa=0",      "rov_mul_e001_k0"),
                ("eps=0.001 kappa=1",      "rov_mul_e001_k1"),
                ("eps=0.27 kappa=0",       "rov_mul_e027_k0"),
                ("eps=0.27 shuffle",       "rov_mul_e027_k0_shuf"),
                ("eps=0.40 kappa=0",       "rov_mul_e040_k0"),
                ("eps=0.40 shuffle",       "rov_mul_e040_k0_shuf"),
                ("eps=0.60 kappa=0",       "rov_mul_e060_k0"),
            ]),
        ]),
    "rovers": dict(
        base="rov_base",
        probe="example/probeRov_distinct_d5-22",
        optlen="optlen_rovers_distinct.json",
        tables=[
            ("ADDITIVE", [
                ("beta=1 kappa=1",         "rov_abs_t1b1k1"),
                ("beta=1 kappa=0 (prior)", "rov_abs_t1b1k0"),
                ("beta=2 kappa=1",         "rov_abs_t1b2k1"),
                ("beta=0 kappa=1 (c(s))",  "rov_abs_t1b0k1"),
                ("shuffle",                "rov_abs_t1b1k1_shuf"),
                ("random",                 "rov_abs_t1b1k1_rndm"),
            ]),
            # eps=0.27 is rovers' OWN matched mass (W=0.274 at beta=1, distinct TEST probes).
            ("MULTIPLICATIVE", [
                ("eps=0.001 kappa=0",      "rov_mul_e001_k0"),
                ("eps=0.001 kappa=1",      "rov_mul_e001_k1"),
                ("eps=0.27 kappa=0",       "rov_mul_e027_k0"),
                ("eps=0.27 shuffle",       "rov_mul_e027_k0_shuf"),
                ("eps=0.40 kappa=0",       "rov_mul_e040_k0"),
                ("eps=0.40 shuffle",       "rov_mul_e040_k0_shuf"),
                ("eps=0.60 kappa=0",       "rov_mul_e060_k0"),
            ]),
        ]),
    "logistics": dict(
        # Rebuilt on the distinct probe set (2026-08-11). The old set --
        # probeLog_multiloc_d5-20, baseline multiloc_base_topopolicy -- drew 288 probes
        # from only 18 source problems, the worst ratio in the study.
        # eps=0.30 is logistics' OWN matched mass (W=0.301 at beta=1, refit on these
        # probes); the old config said 0.29, fitted on the 288-probe set.
        # CROSS-DATASET: probes come from logistics_dataset/test (v1) while the models are
        # logistics_topo_*, trained on logistics_dataset_topo, which has no test split.
        base="log_base",
        probe="example/probeLog_distinct_d5-22",
        optlen="optlen_logistics_distinct.json",
        tables=[
            ("ADDITIVE", [
                ("beta=1 kappa=1",         "log_abs_t1b1k1"),
                ("beta=1 kappa=0",         "log_abs_t1b1k0"),
                ("beta=2 kappa=1",         "log_abs_t1b2k1"),
                ("beta=0 kappa=1 (c(s))",  "log_abs_t1b0k1"),
                ("shuffle",                "log_abs_t1b1k1_shuf"),
                ("random",                 "log_abs_t1b1k1_rndm"),
            ]),
            ("MULTIPLICATIVE", [
                ("eps=0.001 kappa=0",      "log_mul_e001_k0"),
                ("eps=0.001 kappa=1",      "log_mul_e001_k1"),
                ("eps=0.30 kappa=0",       "log_mul_e030_k0"),
                ("eps=0.30 shuffle",       "log_mul_e030_k0_shuf"),
                ("eps=0.40 kappa=0",       "log_mul_e040_k0"),
                ("eps=0.40 shuffle",       "log_mul_e040_k0_shuf"),
                ("eps=0.60 kappa=0",       "log_mul_e060_k0"),
            ]),
        ]),
    # The c_puct = 2.87 rerun (grid's measured DeltaU/DeltaQ is 0.523).
    "grid_cp287": dict(
        base="grid_base_cp287",
        probe="example/probeGrid_distinct_d5-22",
        optlen="optlen_grid_distinct.json",
        tables=[
            ("ADDITIVE (c_puct=2.87)", [
                ("beta=1 kappa=1",         "grid_abs_t1b1k1_cp287"),
                ("random",                 "grid_abs_t1b1k1_rndm_cp287"),
            ]),
        ]),
    # The c_puct = 2.69 rerun (rovers' measured DeltaU/DeltaQ is 0.558).
    "rovers_cp269": dict(
        base="rov_base_cp269",
        probe="example/probeRov_distinct_d5-22",
        optlen="optlen_rovers_distinct.json",
        tables=[
            ("ADDITIVE (c_puct=2.69)", [
                ("beta=1 kappa=1",         "rov_abs_t1b1k1_cp269"),
                ("random",                 "rov_abs_t1b1k1_rndm_cp269"),
            ]),
        ]),
    # The c_puct = 2.97 rerun (goldminer's measured DeltaU/DeltaQ is 0.504).
    # CAUTION: goldminer's median branching is 2, so the random control fails its own fit
    # diagnostic (drawn g_s spread 0.1226 vs real 0.1222 -- no reduction). Read the random
    # row here as weak evidence; the flat arms are the only clean control on this domain.
    "goldminer_cp297": dict(
        base="gm_base_cp297",
        probe="example/probeGold_distinct_d5-22",
        optlen="optlen_goldminer_distinct.json",
        tables=[
            ("ADDITIVE (c_puct=2.97)", [
                ("beta=1 kappa=1",         "gm_abs_t1b1k1_cp297"),
                ("random",                 "gm_abs_t1b1k1_rndm_cp297"),
            ]),
        ]),
    # The c_puct = 2.04 rerun (satellite's measured DeltaU/DeltaQ is 0.735, so 1.5/0.735).
    # Its own baseline, for the same reason as logistics_cp346: a comparison is only valid
    # within one exploration constant. Only the additive pair is listed so the table lines
    # up row-for-row with logistics_cp346; sat_mul_e025_k0_cp204 and sat_flat025_cp204 also
    # exist and are compared directly with cluster_contrib.
    "satellite_cp204": dict(
        base="sat_base_cp204",
        probe="example/probeSat_distinct_d5-22",
        optlen="optlen_satellite_distinct.json",
        tables=[
            ("ADDITIVE (c_puct=2.04)", [
                ("beta=1 kappa=1",         "sat_abs_t1b1k1_cp204"),
                ("random",                 "sat_abs_t1b1k1_rndm_cp204"),
            ]),
        ]),
    # The c_puct = 3.46 rerun (logistics' measured DeltaU/DeltaQ is 0.433, so 1.5/0.433).
    # Same probes, same optlen, different exploration constant -- so it needs its own
    # baseline: a comparison is only valid within one c_puct. Kept as a separate domain key
    # rather than replacing "logistics", because both columns belong in the writeup.
    "logistics_cp346": dict(
        base="log_base_cp346",
        probe="example/probeLog_distinct_d5-22",
        optlen="optlen_logistics_distinct.json",
        tables=[
            ("ADDITIVE (c_puct=3.46)", [
                ("beta=1 kappa=1",         "log_abs_t1b1k1_cp346"),
                ("random",                 "log_abs_t1b1k1_rndm_cp346"),
            ]),
        ]),
    "grid": dict(
        # Rebuilt on the distinct probe set (2026-08-11). The old set --
        # probe_near_goal_d5-20, baseline az_probe_qrval_base -- drew 480 probes from
        # only 30 source problems, so every per-probe count was inflated ~16x.
        # eps=0.27 is grid's OWN matched mass (W=0.265 at beta=1, refit on these probes).
        base="grid_base",
        probe="example/probeGrid_distinct_d5-22",
        optlen="optlen_grid_distinct.json",
        tables=[
            ("ADDITIVE", [
                ("beta=1 kappa=1",         "grid_abs_t1b1k1"),
                ("beta=1 kappa=0",         "grid_abs_t1b1k0"),
                ("beta=2 kappa=1",         "grid_abs_t1b2k1"),
                ("beta=0 kappa=1 (c(s))",  "grid_abs_t1b0k1"),
                ("shuffle",                "grid_abs_t1b1k1_shuf"),
                ("random",                 "grid_abs_t1b1k1_rndm"),
            ]),
            ("MULTIPLICATIVE", [
                ("eps=0.001 kappa=0",      "grid_mul_e001_k0"),
                ("eps=0.001 kappa=1",      "grid_mul_e001_k1"),
                ("eps=0.27 kappa=0",       "grid_mul_e027_k0"),
                ("eps=0.27 shuffle",       "grid_mul_e027_k0_shuf"),
                ("eps=0.40 kappa=0",       "grid_mul_e040_k0"),
                ("eps=0.40 shuffle",       "grid_mul_e040_k0_shuf"),
                ("eps=0.60 kappa=0",       "grid_mul_e060_k0"),
            ]),
        ]),
}

