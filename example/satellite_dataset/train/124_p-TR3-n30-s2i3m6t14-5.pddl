(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	satellite1 - satellite
	instrument3 - instrument
	instrument4 - instrument
	instrument5 - instrument
	infrared5 - mode
	thermograph2 - mode
	infrared4 - mode
	infrared1 - mode
	infrared3 - mode
	image0 - mode
	Star0 - direction
	GroundStation6 - direction
	Star8 - direction
	GroundStation10 - direction
	GroundStation1 - direction
	GroundStation9 - direction
	Star3 - direction
	Star7 - direction
	Star4 - direction
	Star2 - direction
	GroundStation5 - direction
	GroundStation12 - direction
	GroundStation11 - direction
	Star13 - direction
	Planet14 - direction
	Phenomenon15 - direction
	Star16 - direction
	Star17 - direction
)
(:init
	(supports instrument0 thermograph2)
	(calibration_target instrument0 GroundStation9)
	(calibration_target instrument0 GroundStation1)
	(supports instrument1 image0)
	(supports instrument1 infrared5)
	(calibration_target instrument1 Star4)
	(calibration_target instrument1 Star7)
	(calibration_target instrument1 Star3)
	(supports instrument2 infrared1)
	(supports instrument2 infrared5)
	(supports instrument2 infrared4)
	(calibration_target instrument2 Star2)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation12)
	(supports instrument3 infrared3)
	(supports instrument3 thermograph2)
	(supports instrument3 infrared4)
	(calibration_target instrument3 Star2)
	(supports instrument4 thermograph2)
	(supports instrument4 image0)
	(supports instrument4 infrared1)
	(calibration_target instrument4 Star13)
	(supports instrument5 infrared5)
	(calibration_target instrument5 Star13)
	(calibration_target instrument5 GroundStation11)
	(calibration_target instrument5 GroundStation12)
	(calibration_target instrument5 GroundStation5)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(on_board instrument5 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star2)
)
(:goal (and
	(have_image Planet14 infrared3)
	(have_image Planet14 image0)
	(have_image Phenomenon15 infrared3)
	(have_image Star16 infrared1)
	(have_image Star17 image0)
))

)
