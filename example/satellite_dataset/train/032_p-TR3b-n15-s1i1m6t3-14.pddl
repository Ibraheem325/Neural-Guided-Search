(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared2 - mode
	infrared4 - mode
	image3 - mode
	thermograph0 - mode
	spectrograph5 - mode
	image1 - mode
	GroundStation1 - direction
	GroundStation2 - direction
	Star0 - direction
	Planet3 - direction
	Planet4 - direction
	Star5 - direction
	Star6 - direction
)
(:init
	(supports instrument0 infrared2)
	(supports instrument0 image1)
	(supports instrument0 spectrograph5)
	(supports instrument0 thermograph0)
	(supports instrument0 image3)
	(supports instrument0 infrared4)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star6)
)
(:goal (and
	(pointing satellite0 Star6)
	(have_image Planet3 thermograph0)
	(have_image Planet4 thermograph0)
	(have_image Star5 infrared2)
	(have_image Star5 thermograph0)
	(have_image Star6 infrared2)
))

)
