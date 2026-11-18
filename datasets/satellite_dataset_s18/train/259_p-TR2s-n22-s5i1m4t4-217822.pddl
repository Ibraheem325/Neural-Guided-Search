(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	satellite2 - satellite
	instrument2 - instrument
	satellite3 - satellite
	instrument3 - instrument
	satellite4 - satellite
	instrument4 - instrument
	thermograph1 - mode
	infrared3 - mode
	image0 - mode
	thermograph2 - mode
	Star1 - direction
	Star2 - direction
	GroundStation3 - direction
	Star0 - direction
	Star4 - direction
	Phenomenon5 - direction
	Phenomenon6 - direction
	Planet7 - direction
)
(:init
	(supports instrument0 image0)
	(supports instrument0 thermograph2)
	(calibration_target instrument0 Star2)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star2)
	(supports instrument1 infrared3)
	(calibration_target instrument1 GroundStation3)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star4)
	(supports instrument2 thermograph1)
	(supports instrument2 thermograph2)
	(supports instrument2 image0)
	(calibration_target instrument2 GroundStation3)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star1)
	(supports instrument3 thermograph2)
	(calibration_target instrument3 Star0)
	(on_board instrument3 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Star2)
	(supports instrument4 image0)
	(calibration_target instrument4 Star0)
	(on_board instrument4 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Phenomenon5)
)
(:goal (and
	(pointing satellite0 Star1)
	(pointing satellite1 Star4)
	(pointing satellite2 Planet7)
	(pointing satellite3 Planet7)
	(have_image Star4 thermograph1)
	(have_image Phenomenon5 thermograph2)
	(have_image Phenomenon6 thermograph1)
	(have_image Planet7 thermograph2)
))

)
