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
	satellite2 - satellite
	instrument5 - instrument
	instrument6 - instrument
	instrument7 - instrument
	infrared4 - mode
	infrared5 - mode
	infrared3 - mode
	image6 - mode
	infrared1 - mode
	image0 - mode
	thermograph2 - mode
	Star5 - direction
	Star7 - direction
	Star8 - direction
	Star9 - direction
	Star10 - direction
	Star3 - direction
	Star6 - direction
	Star2 - direction
	Star1 - direction
	GroundStation11 - direction
	Star0 - direction
	Star13 - direction
	GroundStation4 - direction
	GroundStation12 - direction
	Planet14 - direction
	Planet15 - direction
	Phenomenon16 - direction
	Phenomenon17 - direction
)
(:init
	(supports instrument0 infrared1)
	(supports instrument0 thermograph2)
	(supports instrument0 infrared4)
	(calibration_target instrument0 Star3)
	(calibration_target instrument0 Star1)
	(supports instrument1 infrared5)
	(supports instrument1 infrared4)
	(supports instrument1 infrared3)
	(calibration_target instrument1 Star2)
	(supports instrument2 infrared5)
	(calibration_target instrument2 Star3)
	(calibration_target instrument2 GroundStation12)
	(calibration_target instrument2 Star0)
	(calibration_target instrument2 Star1)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation4)
	(supports instrument3 infrared1)
	(calibration_target instrument3 Star6)
	(calibration_target instrument3 GroundStation4)
	(calibration_target instrument3 GroundStation12)
	(supports instrument4 infrared3)
	(calibration_target instrument4 GroundStation11)
	(calibration_target instrument4 Star1)
	(calibration_target instrument4 Star2)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star3)
	(supports instrument5 thermograph2)
	(supports instrument5 infrared4)
	(calibration_target instrument5 Star0)
	(supports instrument6 image6)
	(supports instrument6 image0)
	(calibration_target instrument6 Star13)
	(supports instrument7 infrared1)
	(calibration_target instrument7 GroundStation12)
	(calibration_target instrument7 GroundStation4)
	(calibration_target instrument7 Star13)
	(on_board instrument5 satellite2)
	(on_board instrument6 satellite2)
	(on_board instrument7 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star9)
)
(:goal (and
	(have_image Planet14 infrared1)
	(have_image Planet14 infrared3)
	(have_image Planet15 infrared4)
	(have_image Planet15 infrared1)
	(have_image Phenomenon16 thermograph2)
	(have_image Phenomenon16 image6)
	(have_image Phenomenon17 image0)
	(have_image Phenomenon17 infrared5)
))

)
