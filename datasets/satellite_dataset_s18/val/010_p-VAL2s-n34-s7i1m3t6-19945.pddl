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
	satellite5 - satellite
	instrument5 - instrument
	satellite6 - satellite
	instrument6 - instrument
	thermograph0 - mode
	image1 - mode
	image2 - mode
	GroundStation0 - direction
	Star4 - direction
	Star5 - direction
	Star2 - direction
	GroundStation3 - direction
	GroundStation1 - direction
	Star6 - direction
	Phenomenon7 - direction
	Phenomenon8 - direction
	Star9 - direction
	Phenomenon10 - direction
	Planet11 - direction
	Phenomenon12 - direction
	Planet13 - direction
	Planet14 - direction
	Phenomenon15 - direction
	Phenomenon16 - direction
)
(:init
	(supports instrument0 thermograph0)
	(supports instrument0 image2)
	(calibration_target instrument0 Star2)
	(calibration_target instrument0 GroundStation1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon8)
	(supports instrument1 image1)
	(calibration_target instrument1 Star5)
	(calibration_target instrument1 GroundStation1)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Planet14)
	(supports instrument2 image1)
	(calibration_target instrument2 Star4)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Planet11)
	(supports instrument3 image2)
	(supports instrument3 thermograph0)
	(supports instrument3 image1)
	(calibration_target instrument3 Star2)
	(calibration_target instrument3 GroundStation3)
	(on_board instrument3 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Star5)
	(supports instrument4 image1)
	(supports instrument4 image2)
	(supports instrument4 thermograph0)
	(calibration_target instrument4 Star5)
	(on_board instrument4 satellite4)
	(power_avail satellite4)
	(pointing satellite4 GroundStation3)
	(supports instrument5 thermograph0)
	(supports instrument5 image2)
	(supports instrument5 image1)
	(calibration_target instrument5 Star2)
	(on_board instrument5 satellite5)
	(power_avail satellite5)
	(pointing satellite5 GroundStation3)
	(supports instrument6 image2)
	(supports instrument6 image1)
	(supports instrument6 thermograph0)
	(calibration_target instrument6 GroundStation1)
	(calibration_target instrument6 GroundStation3)
	(on_board instrument6 satellite6)
	(power_avail satellite6)
	(pointing satellite6 Phenomenon15)
)
(:goal (and
	(pointing satellite0 Phenomenon7)
	(pointing satellite1 Phenomenon7)
	(pointing satellite3 Phenomenon8)
	(pointing satellite4 Star5)
	(have_image Star6 image2)
	(have_image Phenomenon7 thermograph0)
	(have_image Phenomenon8 image1)
	(have_image Star9 image2)
	(have_image Phenomenon10 image1)
	(have_image Planet11 image1)
	(have_image Phenomenon12 thermograph0)
	(have_image Planet13 thermograph0)
	(have_image Planet14 image2)
	(have_image Phenomenon15 image2)
	(have_image Phenomenon16 image1)
))

)
