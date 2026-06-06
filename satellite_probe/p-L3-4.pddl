(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	satellite1 - satellite
	instrument3 - instrument
	instrument4 - instrument
	satellite2 - satellite
	instrument5 - instrument
	infrared2 - mode
	image3 - mode
	thermograph0 - mode
	infrared1 - mode
	Star0 - direction
	Star3 - direction
	Star4 - direction
	GroundStation8 - direction
	Star9 - direction
	Star11 - direction
	Star12 - direction
	Star14 - direction
	Star16 - direction
	GroundStation18 - direction
	Star19 - direction
	GroundStation22 - direction
	Star23 - direction
	GroundStation21 - direction
	GroundStation5 - direction
	GroundStation2 - direction
	GroundStation1 - direction
	GroundStation10 - direction
	GroundStation20 - direction
	GroundStation6 - direction
	Star17 - direction
	GroundStation15 - direction
	Star24 - direction
	Star7 - direction
	Star13 - direction
	Planet25 - direction
	Star26 - direction
	Star27 - direction
	Star28 - direction
	Star29 - direction
	Planet30 - direction
	Star31 - direction
	Planet32 - direction
	Planet33 - direction
	Phenomenon34 - direction
	Phenomenon35 - direction
	Phenomenon36 - direction
	Star37 - direction
	Phenomenon38 - direction
	Planet39 - direction
)
(:init
	(supports instrument0 infrared1)
	(calibration_target instrument0 GroundStation2)
	(calibration_target instrument0 GroundStation15)
	(calibration_target instrument0 GroundStation21)
	(calibration_target instrument0 GroundStation1)
	(supports instrument1 infrared2)
	(supports instrument1 infrared1)
	(calibration_target instrument1 GroundStation10)
	(calibration_target instrument1 GroundStation21)
	(supports instrument2 thermograph0)
	(supports instrument2 infrared2)
	(supports instrument2 image3)
	(calibration_target instrument2 GroundStation2)
	(calibration_target instrument2 GroundStation5)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation21)
	(supports instrument3 infrared2)
	(calibration_target instrument3 Star17)
	(calibration_target instrument3 GroundStation6)
	(calibration_target instrument3 GroundStation20)
	(calibration_target instrument3 GroundStation10)
	(calibration_target instrument3 GroundStation1)
	(supports instrument4 infrared2)
	(calibration_target instrument4 Star7)
	(calibration_target instrument4 Star24)
	(calibration_target instrument4 GroundStation15)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation10)
	(supports instrument5 thermograph0)
	(supports instrument5 image3)
	(calibration_target instrument5 Star13)
	(on_board instrument5 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Planet25)
)
(:goal (and
	(pointing satellite0 Star14)
	(have_image Planet25 infrared1)
	(have_image Star26 infrared1)
	(have_image Star27 image3)
	(have_image Star28 thermograph0)
	(have_image Star29 thermograph0)
	(have_image Planet30 infrared1)
	(have_image Star31 infrared1)
	(have_image Planet32 infrared1)
	(have_image Planet33 image3)
	(have_image Phenomenon34 image3)
	(have_image Phenomenon35 infrared1)
	(have_image Phenomenon36 image3)
	(have_image Star37 infrared1)
	(have_image Phenomenon38 image3)
	(have_image Planet39 image3)
))

)
