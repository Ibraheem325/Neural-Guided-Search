(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph2 - mode
	infrared3 - mode
	infrared4 - mode
	image0 - mode
	thermograph1 - mode
	GroundStation0 - direction
	GroundStation1 - direction
	GroundStation2 - direction
	Star3 - direction
	GroundStation5 - direction
	Star4 - direction
	Planet6 - direction
	Planet7 - direction
	Planet8 - direction
	Phenomenon9 - direction
)
(:init
	(supports instrument0 infrared3)
	(supports instrument0 thermograph1)
	(supports instrument0 image0)
	(supports instrument0 infrared4)
	(supports instrument0 spectrograph2)
	(calibration_target instrument0 Star4)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation2)
)
(:goal (and
	(pointing satellite0 Star3)
	(have_image Planet6 spectrograph2)
	(have_image Planet7 thermograph1)
	(have_image Planet8 image0)
	(have_image Phenomenon9 thermograph1)
))

)
