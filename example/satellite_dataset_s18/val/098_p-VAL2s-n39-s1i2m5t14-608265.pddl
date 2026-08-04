(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	infrared2 - mode
	spectrograph3 - mode
	thermograph0 - mode
	image1 - mode
	infrared4 - mode
	Star0 - direction
	GroundStation1 - direction
	Star5 - direction
	Star7 - direction
	GroundStation10 - direction
	Star11 - direction
	Star12 - direction
	Star13 - direction
	GroundStation3 - direction
	GroundStation6 - direction
	GroundStation8 - direction
	GroundStation4 - direction
	GroundStation2 - direction
	GroundStation9 - direction
	Phenomenon14 - direction
	Planet15 - direction
	Phenomenon16 - direction
	Star17 - direction
	Phenomenon18 - direction
	Planet19 - direction
	Planet20 - direction
	Star21 - direction
	Phenomenon22 - direction
	Star23 - direction
	Star24 - direction
	Planet25 - direction
	Star26 - direction
	Planet27 - direction
	Planet28 - direction
	Star29 - direction
	Phenomenon30 - direction
)
(:init
	(supports instrument0 thermograph0)
	(supports instrument0 infrared2)
	(supports instrument0 infrared4)
	(supports instrument0 spectrograph3)
	(calibration_target instrument0 GroundStation6)
	(calibration_target instrument0 GroundStation9)
	(calibration_target instrument0 GroundStation4)
	(calibration_target instrument0 GroundStation3)
	(supports instrument1 infrared2)
	(supports instrument1 image1)
	(calibration_target instrument1 GroundStation9)
	(calibration_target instrument1 GroundStation2)
	(calibration_target instrument1 GroundStation4)
	(calibration_target instrument1 GroundStation8)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star12)
)
(:goal (and
	(have_image Phenomenon14 thermograph0)
	(have_image Planet15 thermograph0)
	(have_image Phenomenon16 infrared2)
	(have_image Star17 infrared4)
	(have_image Phenomenon18 thermograph0)
	(have_image Planet19 spectrograph3)
	(have_image Planet20 image1)
	(have_image Star21 image1)
	(have_image Phenomenon22 spectrograph3)
	(have_image Star23 spectrograph3)
	(have_image Star24 thermograph0)
	(have_image Planet25 spectrograph3)
	(have_image Star26 image1)
	(have_image Planet27 thermograph0)
	(have_image Planet28 infrared4)
	(have_image Star29 infrared2)
	(have_image Phenomenon30 infrared2)
))

)
