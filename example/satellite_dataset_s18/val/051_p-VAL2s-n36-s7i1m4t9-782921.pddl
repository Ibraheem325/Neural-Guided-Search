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
	infrared1 - mode
	thermograph2 - mode
	thermograph3 - mode
	image0 - mode
	GroundStation0 - direction
	GroundStation3 - direction
	Star4 - direction
	GroundStation5 - direction
	Star8 - direction
	GroundStation7 - direction
	Star6 - direction
	Star2 - direction
	GroundStation1 - direction
	Star9 - direction
	Planet10 - direction
	Planet11 - direction
	Star12 - direction
	Phenomenon13 - direction
	Planet14 - direction
	Phenomenon15 - direction
	Planet16 - direction
	Star17 - direction
)
(:init
	(supports instrument0 thermograph2)
	(supports instrument0 image0)
	(supports instrument0 infrared1)
	(calibration_target instrument0 GroundStation5)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation0)
	(supports instrument1 infrared1)
	(calibration_target instrument1 Star2)
	(calibration_target instrument1 Star6)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation5)
	(supports instrument2 image0)
	(supports instrument2 thermograph2)
	(supports instrument2 infrared1)
	(supports instrument2 thermograph3)
	(calibration_target instrument2 GroundStation7)
	(calibration_target instrument2 Star8)
	(calibration_target instrument2 Star6)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Phenomenon13)
	(supports instrument3 image0)
	(supports instrument3 infrared1)
	(calibration_target instrument3 Star6)
	(on_board instrument3 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Planet16)
	(supports instrument4 thermograph2)
	(supports instrument4 infrared1)
	(calibration_target instrument4 GroundStation1)
	(calibration_target instrument4 Star6)
	(on_board instrument4 satellite4)
	(power_avail satellite4)
	(pointing satellite4 GroundStation1)
	(supports instrument5 infrared1)
	(supports instrument5 image0)
	(calibration_target instrument5 Star2)
	(on_board instrument5 satellite5)
	(power_avail satellite5)
	(pointing satellite5 Star2)
	(supports instrument6 image0)
	(calibration_target instrument6 GroundStation1)
	(on_board instrument6 satellite6)
	(power_avail satellite6)
	(pointing satellite6 Star4)
)
(:goal (and
	(pointing satellite0 Star2)
	(pointing satellite1 GroundStation0)
	(pointing satellite3 GroundStation3)
	(pointing satellite5 GroundStation1)
	(have_image Star9 image0)
	(have_image Planet10 infrared1)
	(have_image Planet11 thermograph3)
	(have_image Star12 thermograph3)
	(have_image Phenomenon13 image0)
	(have_image Planet14 thermograph2)
	(have_image Phenomenon15 thermograph2)
	(have_image Planet16 infrared1)
	(have_image Star17 image0)
))

)
