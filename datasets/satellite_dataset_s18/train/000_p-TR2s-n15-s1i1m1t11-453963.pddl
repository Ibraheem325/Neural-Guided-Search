(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph0 - mode
	GroundStation0 - direction
	Star1 - direction
	GroundStation2 - direction
	Star3 - direction
	Star4 - direction
	Star5 - direction
	Star6 - direction
	GroundStation10 - direction
	GroundStation7 - direction
	Star8 - direction
	Star9 - direction
	Planet11 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 Star9)
	(calibration_target instrument0 Star8)
	(calibration_target instrument0 GroundStation7)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star1)
)
(:goal (and
	(have_image Planet11 spectrograph0)
))

)
