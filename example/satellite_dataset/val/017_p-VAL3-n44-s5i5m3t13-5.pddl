(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	satellite1 - satellite
	instrument3 - instrument
	satellite2 - satellite
	instrument4 - instrument
	satellite3 - satellite
	instrument5 - instrument
	instrument6 - instrument
	satellite4 - satellite
	instrument7 - instrument
	instrument8 - instrument
	thermograph2 - mode
	infrared1 - mode
	image0 - mode
	Star3 - direction
	Star11 - direction
	Star1 - direction
	Star12 - direction
	GroundStation5 - direction
	Star0 - direction
	Star4 - direction
	Star2 - direction
	GroundStation8 - direction
	Star10 - direction
	GroundStation7 - direction
	Star9 - direction
	Star6 - direction
	Phenomenon13 - direction
	Phenomenon14 - direction
	Planet15 - direction
	Planet16 - direction
)
(:init
	(supports instrument0 image0)
	(supports instrument0 thermograph2)
	(calibration_target instrument0 Star12)
	(calibration_target instrument0 Star3)
	(supports instrument1 image0)
	(calibration_target instrument1 Star2)
	(calibration_target instrument1 Star10)
	(calibration_target instrument1 Star6)
	(calibration_target instrument1 GroundStation5)
	(supports instrument2 thermograph2)
	(calibration_target instrument2 Star9)
	(calibration_target instrument2 Star12)
	(calibration_target instrument2 Star1)
	(calibration_target instrument2 Star11)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star0)
	(supports instrument3 thermograph2)
	(supports instrument3 infrared1)
	(calibration_target instrument3 Star2)
	(calibration_target instrument3 Star6)
	(on_board instrument3 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Phenomenon14)
	(supports instrument4 infrared1)
	(calibration_target instrument4 Star4)
	(calibration_target instrument4 Star9)
	(calibration_target instrument4 GroundStation5)
	(on_board instrument4 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Planet15)
	(supports instrument5 thermograph2)
	(supports instrument5 infrared1)
	(supports instrument5 image0)
	(calibration_target instrument5 GroundStation7)
	(supports instrument6 thermograph2)
	(calibration_target instrument6 Star4)
	(calibration_target instrument6 Star2)
	(calibration_target instrument6 Star0)
	(calibration_target instrument6 Star9)
	(on_board instrument5 satellite3)
	(on_board instrument6 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Star3)
	(supports instrument7 infrared1)
	(calibration_target instrument7 Star10)
	(calibration_target instrument7 GroundStation8)
	(calibration_target instrument7 Star2)
	(supports instrument8 thermograph2)
	(calibration_target instrument8 Star6)
	(calibration_target instrument8 Star9)
	(calibration_target instrument8 GroundStation7)
	(on_board instrument7 satellite4)
	(on_board instrument8 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Star4)
)
(:goal (and
	(pointing satellite2 Star12)
	(pointing satellite3 Star3)
	(have_image Phenomenon13 infrared1)
	(have_image Phenomenon14 thermograph2)
	(have_image Planet15 infrared1)
	(have_image Planet16 thermograph2)
))

)
