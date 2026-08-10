"""Shared arm/probe/baseline configuration for the five domains.

Extracted so table_plan_len.py and table_by_base.py cannot drift apart -- they must report
the same arms over the same probe sets, or the per-probe and per-base-problem views of the
same sweep stop being comparable.

Each entry: base results dir, probe dir, FD optimal-length json, and the tables (label ->
results dir) in the order they should print.
"""

DOMAINS = {
    "goldminer": dict(
        base="gm_base",
        probe="example/probeGold_near_goal_d5-20",
        optlen="optlen_goldminer.json",
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
                ("eps=0.28 kappa=0",       "gm_mul_e028_k0"),
                ("eps=0.40 kappa=0",       "gm_mul_e040_k0"),
                ("eps=0.60 kappa=0",       "gm_mul_e060_k0"),
                ("eps=0.28 shuffle",       "gm_mul_e028_k0_shuf"),
            ]),
        ]),
    "satellite": dict(
        base="sat_base",
        probe="example/probeSat_val_d5-20",
        optlen="optlen_satellite.json",
        tables=[
            ("ADDITIVE", [
                ("beta=1 kappa=1",         "sat_abs_t1b1k1"),
                ("beta=1 kappa=0 (prior)", "sat_abs_t1b1k0"),
                ("beta=2 kappa=1",         "sat_abs_t1b2k1"),
                ("beta=0 kappa=1 (c(s))",  "sat_abs_t1b0k1"),
                ("shuffle",                "sat_abs_t1b1k1_shuf"),
                ("random",                 "sat_abs_t1b1k1_rndm"),
            ]),
            # eps=0.23 is satellite's OWN matched mass (W=0.227 at beta=1), the analogue of
            # grid 0.27 / goldminer 0.28 / logistics 0.29.
            ("MULTIPLICATIVE", [
                ("eps=0.001 kappa=0",      "sat_mul_e001_k0"),
                ("eps=0.001 kappa=1",      "sat_mul_e001_k1"),
                ("eps=0.23 kappa=0",       "sat_mul_e023_k0"),
                ("eps=0.23 shuffle",       "sat_mul_e023_k0_shuf"),
                ("eps=0.40 kappa=0",       "sat_mul_e040_k0"),
                ("eps=0.40 shuffle",       "sat_mul_e040_k0_shuf"),
                ("eps=0.60 kappa=0",       "sat_mul_e060_k0"),
            ]),
        ]),
    "rovers": dict(
        base="rov_base",
        probe="example/probeRov_test_d5-20",
        optlen="optlen_rovers_test.json",
        tables=[
            ("ADDITIVE", [
                ("beta=1 kappa=1",         "rov_abs_t1b1k1"),
                ("beta=1 kappa=0 (prior)", "rov_abs_t1b1k0"),
                ("beta=2 kappa=1",         "rov_abs_t1b2k1"),
                ("beta=0 kappa=1 (c(s))",  "rov_abs_t1b0k1"),
                ("shuffle",                "rov_abs_t1b1k1_shuf"),
                ("random",                 "rov_abs_t1b1k1_rndm"),
            ]),
            # eps=0.29 is rovers' OWN matched mass (W=0.288 at beta=1, TEST probes).
            ("MULTIPLICATIVE", [
                ("eps=0.001 kappa=0",      "rov_mul_e001_k0"),
                ("eps=0.001 kappa=1",      "rov_mul_e001_k1"),
                ("eps=0.29 kappa=0",       "rov_mul_e029_k0"),
                ("eps=0.29 shuffle",       "rov_mul_e029_k0_shuf"),
                ("eps=0.40 kappa=0",       "rov_mul_e040_k0"),
                ("eps=0.40 shuffle",       "rov_mul_e040_k0_shuf"),
                ("eps=0.60 kappa=0",       "rov_mul_e060_k0"),
            ]),
        ]),
    "satellite_test": dict(
        base="sat_base_test",
        probe="example/probeSat_test_d5-20",
        optlen="optlen_satellite_test.json",
        tables=[
            # Three-arm replication of the headline result on the TEST split. The full
            # 14-arm sweep is under --domain satellite (val probes).
            ("ADDITIVE (test-split replication)", [
                ("beta=1 kappa=0 (prior)", "sat_abs_t1b1k0_test"),
                ("shuffle",                "sat_abs_t1b1k1_shuf_test"),
            ]),
        ]),
    "logistics": dict(
        base="multiloc_base_topopolicy",
        probe="example/probeLog_multiloc_d5-20",
        optlen="optlen_logistics.json",
        tables=[
            ("ADDITIVE", [
                ("beta=1 kappa=1",         "logi_abs_t1b1k1"),
                ("beta=1 kappa=0",         "logi_abs_t1b1k0"),
                ("beta=2 kappa=1",         "logi_abs_t1b2k1"),
                ("beta=0 kappa=1 (c(s))",  "logi_abs_t1b0k1"),
                ("shuffle",                "logi_abs_t1b1k1_shuf"),
                ("random",                 "logi_abs_t1b1k1_rndm"),
            ]),
            ("MULTIPLICATIVE", [
                ("eps=0.001 kappa=0",      "logi_mul_e001_k0"),
                ("eps=0.001 kappa=1",      "logi_mul_e001_k1"),
                ("eps=0.29 kappa=0",       "logi_mul_e029_k0"),
                ("eps=0.29 shuffle",       "logi_mul_e029_k0_shuf"),
                ("eps=0.40 kappa=0",       "logi_mul_e040_k0"),
                ("eps=0.60 kappa=0",       "logi_mul_e060_k0"),
            ]),
        ]),
    "grid": dict(
        base="az_probe_qrval_base",
        probe="example/probe_near_goal_d5-20",
        optlen="optlen_grid.json",
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

