(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	thermograph2 - mode
	spectrograph1 - mode
	thermograph3 - mode
	infrared4 - mode
	image0 - mode
	GroundStation0 - direction
	GroundStation4 - direction
	Star5 - direction
	GroundStation6 - direction
	Star2 - direction
	Star7 - direction
	GroundStation3 - direction
	GroundStation1 - direction
	Planet8 - direction
)
(:init
	(supports instrument0 spectrograph1)
	(supports instrument0 thermograph3)
	(supports instrument0 infrared4)
	(supports instrument0 thermograph2)
	(calibration_target instrument0 Star7)
	(calibration_target instrument0 Star2)
	(supports instrument1 thermograph3)
	(supports instrument1 spectrograph1)
	(supports instrument1 image0)
	(calibration_target instrument1 GroundStation1)
	(calibration_target instrument1 GroundStation3)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation4)
)
(:goal (and
	(pointing satellite0 Star2)
	(have_image Planet8 spectrograph1)
))

)
