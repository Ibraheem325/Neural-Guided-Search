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
	image4 - mode
	spectrograph0 - mode
	infrared1 - mode
	image3 - mode
	infrared5 - mode
	image2 - mode
	GroundStation0 - direction
	Star3 - direction
	GroundStation4 - direction
	GroundStation8 - direction
	Star12 - direction
	GroundStation18 - direction
	GroundStation21 - direction
	GroundStation23 - direction
	Star26 - direction
	Star5 - direction
	GroundStation10 - direction
	Star24 - direction
	Star14 - direction
	Star15 - direction
	GroundStation6 - direction
	GroundStation22 - direction
	GroundStation9 - direction
	Star16 - direction
	GroundStation7 - direction
	Star28 - direction
	Star25 - direction
	Star19 - direction
	GroundStation11 - direction
	Star27 - direction
	Star1 - direction
	GroundStation13 - direction
	GroundStation20 - direction
	GroundStation2 - direction
	Star17 - direction
	Planet29 - direction
	Star30 - direction
	Phenomenon31 - direction
	Star32 - direction
)
(:init
	(supports instrument0 image2)
	(supports instrument0 spectrograph0)
	(supports instrument0 image4)
	(calibration_target instrument0 GroundStation22)
	(calibration_target instrument0 Star24)
	(calibration_target instrument0 GroundStation10)
	(calibration_target instrument0 Star5)
	(calibration_target instrument0 Star28)
	(calibration_target instrument0 Star16)
	(calibration_target instrument0 GroundStation13)
	(supports instrument1 image3)
	(calibration_target instrument1 Star15)
	(calibration_target instrument1 Star1)
	(calibration_target instrument1 Star14)
	(supports instrument2 spectrograph0)
	(supports instrument2 infrared5)
	(supports instrument2 image4)
	(calibration_target instrument2 GroundStation9)
	(calibration_target instrument2 GroundStation22)
	(calibration_target instrument2 GroundStation6)
	(calibration_target instrument2 GroundStation2)
	(calibration_target instrument2 Star28)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation6)
	(supports instrument3 spectrograph0)
	(calibration_target instrument3 Star25)
	(calibration_target instrument3 GroundStation2)
	(calibration_target instrument3 Star28)
	(calibration_target instrument3 GroundStation7)
	(calibration_target instrument3 Star16)
	(supports instrument4 image2)
	(supports instrument4 infrared1)
	(calibration_target instrument4 Star17)
	(calibration_target instrument4 GroundStation2)
	(calibration_target instrument4 GroundStation20)
	(calibration_target instrument4 GroundStation13)
	(calibration_target instrument4 Star1)
	(calibration_target instrument4 Star27)
	(calibration_target instrument4 GroundStation11)
	(calibration_target instrument4 Star19)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star1)
)
(:goal (and
	(pointing satellite0 Star12)
	(have_image Planet29 infrared5)
	(have_image Star30 infrared1)
	(have_image Phenomenon31 infrared1)
	(have_image Star32 image2)
))

)
