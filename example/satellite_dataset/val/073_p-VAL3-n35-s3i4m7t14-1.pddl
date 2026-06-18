(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	satellite1 - satellite
	instrument2 - instrument
	instrument3 - instrument
	instrument4 - instrument
	satellite2 - satellite
	instrument5 - instrument
	instrument6 - instrument
	thermograph2 - mode
	image6 - mode
	thermograph0 - mode
	image1 - mode
	infrared5 - mode
	thermograph3 - mode
	thermograph4 - mode
	GroundStation2 - direction
	GroundStation7 - direction
	GroundStation8 - direction
	GroundStation9 - direction
	Star12 - direction
	GroundStation0 - direction
	GroundStation13 - direction
	Star1 - direction
	GroundStation11 - direction
	Star10 - direction
	GroundStation4 - direction
	Star5 - direction
	Star3 - direction
	Star6 - direction
	Phenomenon14 - direction
	Phenomenon15 - direction
	Star16 - direction
	Star17 - direction
)
(:init
	(supports instrument0 image6)
	(calibration_target instrument0 GroundStation0)
	(calibration_target instrument0 Star6)
	(calibration_target instrument0 GroundStation13)
	(supports instrument1 image1)
	(supports instrument1 thermograph2)
	(supports instrument1 thermograph4)
	(supports instrument1 infrared5)
	(calibration_target instrument1 GroundStation11)
	(calibration_target instrument1 GroundStation13)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon14)
	(supports instrument2 image6)
	(supports instrument2 thermograph4)
	(calibration_target instrument2 Star5)
	(calibration_target instrument2 GroundStation13)
	(supports instrument3 thermograph2)
	(supports instrument3 image1)
	(calibration_target instrument3 GroundStation4)
	(calibration_target instrument3 GroundStation11)
	(calibration_target instrument3 Star1)
	(supports instrument4 thermograph3)
	(supports instrument4 image1)
	(calibration_target instrument4 Star10)
	(calibration_target instrument4 GroundStation11)
	(on_board instrument2 satellite1)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation8)
	(supports instrument5 thermograph0)
	(calibration_target instrument5 Star3)
	(calibration_target instrument5 Star5)
	(calibration_target instrument5 GroundStation4)
	(supports instrument6 thermograph2)
	(calibration_target instrument6 Star6)
	(on_board instrument5 satellite2)
	(on_board instrument6 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation2)
)
(:goal (and
	(have_image Phenomenon14 infrared5)
	(have_image Phenomenon15 thermograph4)
	(have_image Phenomenon15 thermograph3)
	(have_image Star16 thermograph3)
	(have_image Star16 thermograph0)
	(have_image Star17 image6)
	(have_image Star17 thermograph0)
))

)
