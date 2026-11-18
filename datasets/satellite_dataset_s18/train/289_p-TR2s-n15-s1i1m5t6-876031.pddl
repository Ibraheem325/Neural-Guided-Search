(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph0 - mode
	spectrograph4 - mode
	spectrograph1 - mode
	thermograph2 - mode
	spectrograph3 - mode
	GroundStation0 - direction
	Star1 - direction
	GroundStation2 - direction
	GroundStation3 - direction
	Star5 - direction
	Star4 - direction
	Star6 - direction
	Planet7 - direction
)
(:init
	(supports instrument0 spectrograph3)
	(supports instrument0 spectrograph4)
	(supports instrument0 thermograph2)
	(supports instrument0 spectrograph1)
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 Star4)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation2)
)
(:goal (and
	(pointing satellite0 GroundStation3)
	(have_image Star6 thermograph2)
	(have_image Planet7 thermograph2)
))

)
