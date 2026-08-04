(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	satellite1 - satellite
	instrument2 - instrument
	image0 - mode
	Star1 - direction
	GroundStation2 - direction
	Star6 - direction
	Star8 - direction
	GroundStation11 - direction
	Star14 - direction
	GroundStation17 - direction
	Star18 - direction
	Star21 - direction
	Star24 - direction
	Star4 - direction
	GroundStation23 - direction
	GroundStation5 - direction
	GroundStation0 - direction
	GroundStation13 - direction
	Star20 - direction
	Star10 - direction
	GroundStation3 - direction
	Star9 - direction
	Star7 - direction
	GroundStation15 - direction
	GroundStation19 - direction
	Star12 - direction
	GroundStation22 - direction
	Star16 - direction
	Planet25 - direction
	Star26 - direction
	Star27 - direction
	Phenomenon28 - direction
	Phenomenon29 - direction
	Planet30 - direction
	Star31 - direction
	Phenomenon32 - direction
	Planet33 - direction
	Star34 - direction
	Planet35 - direction
	Phenomenon36 - direction
	Star37 - direction
	Star38 - direction
)
(:init
	(supports instrument0 image0)
	(calibration_target instrument0 GroundStation22)
	(calibration_target instrument0 GroundStation0)
	(calibration_target instrument0 GroundStation5)
	(calibration_target instrument0 GroundStation23)
	(calibration_target instrument0 Star4)
	(supports instrument1 image0)
	(calibration_target instrument1 Star9)
	(calibration_target instrument1 GroundStation3)
	(calibration_target instrument1 Star10)
	(calibration_target instrument1 Star20)
	(calibration_target instrument1 Star12)
	(calibration_target instrument1 GroundStation22)
	(calibration_target instrument1 GroundStation13)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star20)
	(supports instrument2 image0)
	(calibration_target instrument2 Star16)
	(calibration_target instrument2 GroundStation22)
	(calibration_target instrument2 Star12)
	(calibration_target instrument2 GroundStation19)
	(calibration_target instrument2 GroundStation15)
	(calibration_target instrument2 Star7)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star21)
)
(:goal (and
	(pointing satellite1 GroundStation3)
	(have_image Planet25 image0)
	(have_image Star26 image0)
	(have_image Star27 image0)
	(have_image Phenomenon28 image0)
	(have_image Phenomenon29 image0)
	(have_image Planet30 image0)
	(have_image Star31 image0)
	(have_image Phenomenon32 image0)
	(have_image Planet33 image0)
	(have_image Star34 image0)
	(have_image Planet35 image0)
	(have_image Phenomenon36 image0)
	(have_image Star37 image0)
	(have_image Star38 image0)
))

)
