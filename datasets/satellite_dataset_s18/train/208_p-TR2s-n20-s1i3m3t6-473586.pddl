(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	thermograph2 - mode
	infrared0 - mode
	thermograph1 - mode
	GroundStation3 - direction
	Star4 - direction
	Star1 - direction
	Star2 - direction
	Star5 - direction
	Star0 - direction
	Planet6 - direction
	Phenomenon7 - direction
	Planet8 - direction
	Phenomenon9 - direction
	Planet10 - direction
	Planet11 - direction
	Phenomenon12 - direction
)
(:init
	(supports instrument0 thermograph2)
	(supports instrument0 infrared0)
	(supports instrument0 thermograph1)
	(calibration_target instrument0 Star2)
	(supports instrument1 thermograph1)
	(calibration_target instrument1 Star2)
	(calibration_target instrument1 Star1)
	(supports instrument2 thermograph1)
	(supports instrument2 thermograph2)
	(calibration_target instrument2 Star0)
	(calibration_target instrument2 Star5)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star1)
)
(:goal (and
	(pointing satellite0 Planet11)
	(have_image Planet6 thermograph1)
	(have_image Phenomenon7 thermograph2)
	(have_image Planet8 infrared0)
	(have_image Phenomenon9 thermograph2)
	(have_image Planet10 thermograph2)
	(have_image Planet11 thermograph1)
	(have_image Phenomenon12 thermograph2)
))

)
