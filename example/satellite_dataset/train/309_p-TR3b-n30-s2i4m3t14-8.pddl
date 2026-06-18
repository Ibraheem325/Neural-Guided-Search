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
	instrument6 - instrument
	thermograph1 - mode
	image0 - mode
	thermograph2 - mode
	GroundStation9 - direction
	Star2 - direction
	Star7 - direction
	GroundStation8 - direction
	GroundStation4 - direction
	Star3 - direction
	Star6 - direction
	Star10 - direction
	GroundStation1 - direction
	GroundStation5 - direction
	Star0 - direction
	GroundStation11 - direction
	GroundStation13 - direction
	GroundStation12 - direction
	Phenomenon14 - direction
	Star15 - direction
	Phenomenon16 - direction
	Phenomenon17 - direction
)
(:init
	(supports instrument0 thermograph2)
	(supports instrument0 image0)
	(supports instrument0 thermograph1)
	(calibration_target instrument0 GroundStation12)
	(calibration_target instrument0 Star2)
	(calibration_target instrument0 GroundStation9)
	(calibration_target instrument0 GroundStation1)
	(supports instrument1 thermograph1)
	(supports instrument1 image0)
	(supports instrument1 thermograph2)
	(calibration_target instrument1 GroundStation12)
	(calibration_target instrument1 Star7)
	(calibration_target instrument1 Star10)
	(supports instrument2 image0)
	(calibration_target instrument2 Star6)
	(calibration_target instrument2 Star10)
	(calibration_target instrument2 GroundStation4)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon17)
	(supports instrument3 thermograph1)
	(supports instrument3 image0)
	(calibration_target instrument3 Star3)
	(calibration_target instrument3 GroundStation4)
	(calibration_target instrument3 GroundStation8)
	(calibration_target instrument3 Star7)
	(supports instrument4 thermograph1)
	(calibration_target instrument4 GroundStation1)
	(calibration_target instrument4 Star0)
	(calibration_target instrument4 Star10)
	(calibration_target instrument4 Star6)
	(supports instrument5 image0)
	(supports instrument5 thermograph1)
	(calibration_target instrument5 GroundStation13)
	(calibration_target instrument5 GroundStation11)
	(calibration_target instrument5 Star0)
	(calibration_target instrument5 GroundStation5)
	(supports instrument6 thermograph1)
	(supports instrument6 image0)
	(calibration_target instrument6 GroundStation12)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(on_board instrument5 satellite1)
	(on_board instrument6 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Phenomenon14)
)
(:goal (and
	(have_image Phenomenon14 image0)
	(have_image Star15 thermograph1)
	(have_image Phenomenon16 image0)
	(have_image Phenomenon17 image0)
))

)
