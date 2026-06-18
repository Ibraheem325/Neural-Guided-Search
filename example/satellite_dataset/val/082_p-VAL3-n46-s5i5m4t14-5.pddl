(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	satellite1 - satellite
	instrument2 - instrument
	satellite2 - satellite
	instrument3 - instrument
	satellite3 - satellite
	instrument4 - instrument
	satellite4 - satellite
	instrument5 - instrument
	instrument6 - instrument
	thermograph2 - mode
	infrared3 - mode
	image0 - mode
	infrared1 - mode
	Star3 - direction
	Star8 - direction
	GroundStation9 - direction
	GroundStation10 - direction
	GroundStation2 - direction
	Star13 - direction
	Star6 - direction
	Star11 - direction
	Star5 - direction
	Star1 - direction
	Star12 - direction
	Star0 - direction
	GroundStation7 - direction
	Star4 - direction
	Phenomenon14 - direction
	Phenomenon15 - direction
	Star16 - direction
	Planet17 - direction
)
(:init
	(supports instrument0 infrared3)
	(supports instrument0 thermograph2)
	(calibration_target instrument0 Star1)
	(supports instrument1 infrared3)
	(supports instrument1 thermograph2)
	(supports instrument1 image0)
	(calibration_target instrument1 GroundStation2)
	(calibration_target instrument1 Star0)
	(calibration_target instrument1 GroundStation7)
	(calibration_target instrument1 Star11)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star12)
	(supports instrument2 image0)
	(supports instrument2 infrared3)
	(calibration_target instrument2 Star13)
	(calibration_target instrument2 Star4)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Phenomenon15)
	(supports instrument3 image0)
	(supports instrument3 infrared1)
	(supports instrument3 thermograph2)
	(calibration_target instrument3 Star6)
	(calibration_target instrument3 Star13)
	(on_board instrument3 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star5)
	(supports instrument4 image0)
	(calibration_target instrument4 Star12)
	(calibration_target instrument4 Star1)
	(calibration_target instrument4 Star5)
	(calibration_target instrument4 Star11)
	(on_board instrument4 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Star5)
	(supports instrument5 thermograph2)
	(supports instrument5 infrared1)
	(calibration_target instrument5 GroundStation7)
	(calibration_target instrument5 Star0)
	(supports instrument6 infrared3)
	(supports instrument6 image0)
	(calibration_target instrument6 Star4)
	(on_board instrument5 satellite4)
	(on_board instrument6 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Star0)
)
(:goal (and
	(pointing satellite4 GroundStation7)
	(have_image Phenomenon14 infrared3)
	(have_image Phenomenon15 infrared1)
	(have_image Star16 infrared1)
	(have_image Planet17 infrared1)
))

)
