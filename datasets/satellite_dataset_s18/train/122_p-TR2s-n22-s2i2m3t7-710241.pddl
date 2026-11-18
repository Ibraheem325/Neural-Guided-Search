(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	satellite1 - satellite
	instrument2 - instrument
	thermograph2 - mode
	image0 - mode
	thermograph1 - mode
	Star0 - direction
	Star2 - direction
	Star4 - direction
	Star5 - direction
	Star1 - direction
	Star6 - direction
	Star3 - direction
	Planet7 - direction
	Planet8 - direction
	Phenomenon9 - direction
	Planet10 - direction
	Phenomenon11 - direction
	Phenomenon12 - direction
	Phenomenon13 - direction
)
(:init
	(supports instrument0 thermograph1)
	(supports instrument0 image0)
	(calibration_target instrument0 Star1)
	(supports instrument1 thermograph2)
	(supports instrument1 thermograph1)
	(supports instrument1 image0)
	(calibration_target instrument1 Star6)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star1)
	(supports instrument2 thermograph2)
	(calibration_target instrument2 Star3)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star0)
)
(:goal (and
	(pointing satellite0 Phenomenon13)
	(have_image Planet7 thermograph2)
	(have_image Planet8 image0)
	(have_image Phenomenon9 thermograph1)
	(have_image Planet10 thermograph2)
	(have_image Phenomenon11 thermograph1)
	(have_image Phenomenon12 image0)
	(have_image Phenomenon13 thermograph1)
))

)
