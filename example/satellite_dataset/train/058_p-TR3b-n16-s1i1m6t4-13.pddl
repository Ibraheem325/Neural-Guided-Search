(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image5 - mode
	spectrograph0 - mode
	image1 - mode
	infrared3 - mode
	spectrograph4 - mode
	thermograph2 - mode
	Star0 - direction
	GroundStation1 - direction
	GroundStation3 - direction
	GroundStation2 - direction
	Planet4 - direction
	Phenomenon5 - direction
	Planet6 - direction
	Phenomenon7 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(supports instrument0 spectrograph4)
	(supports instrument0 thermograph2)
	(supports instrument0 infrared3)
	(supports instrument0 image1)
	(supports instrument0 image5)
	(calibration_target instrument0 GroundStation2)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star0)
)
(:goal (and
	(have_image Planet4 spectrograph4)
	(have_image Phenomenon5 spectrograph0)
	(have_image Planet6 infrared3)
	(have_image Planet6 image1)
	(have_image Phenomenon7 image5)
))

)
