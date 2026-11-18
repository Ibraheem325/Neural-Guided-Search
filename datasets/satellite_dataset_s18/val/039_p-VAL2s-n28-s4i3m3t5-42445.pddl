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
	instrument5 - instrument
	instrument6 - instrument
	satellite3 - satellite
	instrument7 - instrument
	image0 - mode
	thermograph1 - mode
	image2 - mode
	GroundStation1 - direction
	GroundStation3 - direction
	GroundStation4 - direction
	Star0 - direction
	GroundStation2 - direction
	Phenomenon5 - direction
	Planet6 - direction
	Planet7 - direction
	Star8 - direction
	Planet9 - direction
	Planet10 - direction
	Planet11 - direction
	Planet12 - direction
)
(:init
	(supports instrument0 thermograph1)
	(calibration_target instrument0 Star0)
	(supports instrument1 image2)
	(supports instrument1 thermograph1)
	(supports instrument1 image0)
	(calibration_target instrument1 GroundStation2)
	(supports instrument2 image0)
	(supports instrument2 thermograph1)
	(supports instrument2 image2)
	(calibration_target instrument2 GroundStation2)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star8)
	(supports instrument3 thermograph1)
	(calibration_target instrument3 Star0)
	(on_board instrument3 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star0)
	(supports instrument4 image2)
	(supports instrument4 thermograph1)
	(supports instrument4 image0)
	(calibration_target instrument4 GroundStation2)
	(supports instrument5 image2)
	(supports instrument5 thermograph1)
	(calibration_target instrument5 Star0)
	(supports instrument6 image2)
	(supports instrument6 thermograph1)
	(supports instrument6 image0)
	(calibration_target instrument6 Star0)
	(on_board instrument4 satellite2)
	(on_board instrument5 satellite2)
	(on_board instrument6 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation1)
	(supports instrument7 image2)
	(supports instrument7 thermograph1)
	(calibration_target instrument7 GroundStation2)
	(on_board instrument7 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Planet12)
)
(:goal (and
	(pointing satellite2 Planet7)
	(pointing satellite3 Planet11)
	(have_image Phenomenon5 image0)
	(have_image Planet6 thermograph1)
	(have_image Planet7 image2)
	(have_image Star8 image0)
	(have_image Planet9 image0)
	(have_image Planet10 thermograph1)
	(have_image Planet11 image2)
	(have_image Planet12 image2)
))

)
