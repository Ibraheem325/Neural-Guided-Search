(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	instrument2 - instrument
	instrument3 - instrument
	infrared2 - mode
	image3 - mode
	thermograph0 - mode
	infrared1 - mode
	Star0 - direction
	Star3 - direction
	Star4 - direction
	GroundStation6 - direction
	Star7 - direction
	GroundStation8 - direction
	Star9 - direction
	Star12 - direction
	GroundStation15 - direction
	Star17 - direction
	GroundStation18 - direction
	GroundStation10 - direction
	Star13 - direction
	GroundStation2 - direction
	Star16 - direction
	Star19 - direction
	GroundStation5 - direction
	GroundStation1 - direction
	Star14 - direction
	Star11 - direction
	Phenomenon20 - direction
	Phenomenon21 - direction
	Star22 - direction
	Planet23 - direction
	Phenomenon24 - direction
	Phenomenon25 - direction
	Star26 - direction
	Planet27 - direction
	Planet28 - direction
	Phenomenon29 - direction
	Phenomenon30 - direction
	Planet31 - direction
)
(:init
	(supports instrument0 image3)
	(supports instrument0 infrared2)
	(supports instrument0 infrared1)
	(calibration_target instrument0 GroundStation10)
	(calibration_target instrument0 Star14)
	(calibration_target instrument0 Star16)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star0)
	(supports instrument1 infrared2)
	(supports instrument1 infrared1)
	(calibration_target instrument1 Star16)
	(supports instrument2 infrared2)
	(supports instrument2 infrared1)
	(calibration_target instrument2 Star16)
	(calibration_target instrument2 Star19)
	(calibration_target instrument2 GroundStation1)
	(calibration_target instrument2 Star14)
	(calibration_target instrument2 GroundStation2)
	(calibration_target instrument2 Star13)
	(supports instrument3 thermograph0)
	(calibration_target instrument3 Star11)
	(calibration_target instrument3 Star14)
	(calibration_target instrument3 GroundStation1)
	(calibration_target instrument3 GroundStation5)
	(calibration_target instrument3 Star19)
	(on_board instrument1 satellite1)
	(on_board instrument2 satellite1)
	(on_board instrument3 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation1)
)
(:goal (and
	(pointing satellite0 Star11)
	(have_image Phenomenon20 thermograph0)
	(have_image Phenomenon21 thermograph0)
	(have_image Star22 infrared1)
	(have_image Planet23 image3)
	(have_image Phenomenon24 infrared2)
	(have_image Phenomenon25 image3)
	(have_image Star26 infrared2)
	(have_image Planet27 infrared1)
	(have_image Planet28 infrared1)
	(have_image Phenomenon29 thermograph0)
	(have_image Phenomenon30 infrared2)
	(have_image Planet31 infrared1)
))

)
