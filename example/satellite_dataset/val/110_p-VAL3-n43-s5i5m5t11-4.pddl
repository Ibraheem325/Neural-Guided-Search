(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	instrument2 - instrument
	satellite2 - satellite
	instrument3 - instrument
	instrument4 - instrument
	instrument5 - instrument
	instrument6 - instrument
	satellite3 - satellite
	instrument7 - instrument
	satellite4 - satellite
	instrument8 - instrument
	infrared4 - mode
	image3 - mode
	infrared1 - mode
	thermograph0 - mode
	infrared2 - mode
	GroundStation8 - direction
	GroundStation4 - direction
	Star9 - direction
	Star10 - direction
	Star3 - direction
	GroundStation2 - direction
	Star1 - direction
	Star0 - direction
	Star5 - direction
	Star6 - direction
	GroundStation7 - direction
	Planet11 - direction
	Planet12 - direction
	Planet13 - direction
	Star14 - direction
)
(:init
	(supports instrument0 image3)
	(supports instrument0 infrared4)
	(calibration_target instrument0 GroundStation2)
	(calibration_target instrument0 Star1)
	(calibration_target instrument0 GroundStation4)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star14)
	(supports instrument1 infrared1)
	(supports instrument1 thermograph0)
	(supports instrument1 image3)
	(calibration_target instrument1 Star9)
	(calibration_target instrument1 Star3)
	(calibration_target instrument1 Star10)
	(supports instrument2 thermograph0)
	(supports instrument2 infrared2)
	(calibration_target instrument2 Star6)
	(calibration_target instrument2 GroundStation4)
	(calibration_target instrument2 Star3)
	(on_board instrument1 satellite1)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation7)
	(supports instrument3 infrared1)
	(supports instrument3 thermograph0)
	(supports instrument3 image3)
	(calibration_target instrument3 Star0)
	(calibration_target instrument3 Star1)
	(calibration_target instrument3 Star9)
	(supports instrument4 infrared1)
	(supports instrument4 infrared2)
	(supports instrument4 image3)
	(calibration_target instrument4 Star3)
	(calibration_target instrument4 Star10)
	(supports instrument5 infrared4)
	(calibration_target instrument5 GroundStation2)
	(calibration_target instrument5 Star6)
	(supports instrument6 infrared4)
	(supports instrument6 thermograph0)
	(supports instrument6 infrared2)
	(calibration_target instrument6 Star0)
	(calibration_target instrument6 Star1)
	(on_board instrument3 satellite2)
	(on_board instrument4 satellite2)
	(on_board instrument5 satellite2)
	(on_board instrument6 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star6)
	(supports instrument7 thermograph0)
	(supports instrument7 infrared2)
	(supports instrument7 image3)
	(calibration_target instrument7 Star5)
	(on_board instrument7 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Star9)
	(supports instrument8 image3)
	(supports instrument8 thermograph0)
	(calibration_target instrument8 GroundStation7)
	(calibration_target instrument8 Star6)
	(on_board instrument8 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Star9)
)
(:goal (and
	(pointing satellite0 Star5)
	(pointing satellite1 Planet11)
	(have_image Planet11 infrared1)
	(have_image Planet12 infrared1)
	(have_image Planet13 image3)
	(have_image Star14 infrared2)
))

)
