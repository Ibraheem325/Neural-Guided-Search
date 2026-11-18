(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	spectrograph0 - mode
	thermograph2 - mode
	image4 - mode
	thermograph3 - mode
	infrared1 - mode
	GroundStation0 - direction
	Star1 - direction
	GroundStation2 - direction
	GroundStation5 - direction
	Star6 - direction
	GroundStation3 - direction
	Star4 - direction
	Star7 - direction
	Phenomenon8 - direction
	Phenomenon9 - direction
	Phenomenon10 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(supports instrument0 thermograph3)
	(supports instrument0 thermograph2)
	(calibration_target instrument0 Star6)
	(supports instrument1 spectrograph0)
	(supports instrument1 infrared1)
	(supports instrument1 image4)
	(calibration_target instrument1 Star4)
	(calibration_target instrument1 GroundStation3)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon10)
)
(:goal (and
	(pointing satellite0 GroundStation2)
	(have_image Star7 thermograph2)
	(have_image Phenomenon8 image4)
	(have_image Phenomenon9 spectrograph0)
	(have_image Phenomenon10 thermograph3)
))

)
