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
	image0 - mode
	GroundStation5 - direction
	GroundStation12 - direction
	Star29 - direction
	Star30 - direction
	Star25 - direction
	Star10 - direction
	GroundStation4 - direction
	Star1 - direction
	Star28 - direction
	Star24 - direction
	Star16 - direction
	GroundStation7 - direction
	GroundStation31 - direction
	GroundStation19 - direction
	Star8 - direction
	GroundStation11 - direction
	Star0 - direction
	Star14 - direction
	Star18 - direction
	Star6 - direction
	GroundStation27 - direction
	GroundStation20 - direction
	Star17 - direction
	Star26 - direction
	Star21 - direction
	Star33 - direction
	GroundStation32 - direction
	Star2 - direction
	Star34 - direction
	Star22 - direction
	GroundStation9 - direction
	GroundStation3 - direction
	GroundStation23 - direction
	Star15 - direction
	GroundStation13 - direction
	Planet35 - direction
	Planet36 - direction
	Star37 - direction
	Phenomenon38 - direction
	Phenomenon39 - direction
	Phenomenon40 - direction
	Planet41 - direction
	Planet42 - direction
	Star43 - direction
	Phenomenon44 - direction
)
(:init
	(supports instrument0 image0)
	(calibration_target instrument0 Star21)
	(calibration_target instrument0 Star10)
	(calibration_target instrument0 GroundStation32)
	(calibration_target instrument0 Star18)
	(calibration_target instrument0 Star25)
	(calibration_target instrument0 Star26)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star18)
	(supports instrument1 image0)
	(calibration_target instrument1 Star6)
	(calibration_target instrument1 GroundStation27)
	(calibration_target instrument1 Star18)
	(calibration_target instrument1 Star16)
	(calibration_target instrument1 Star14)
	(calibration_target instrument1 Star28)
	(calibration_target instrument1 Star26)
	(calibration_target instrument1 Star1)
	(calibration_target instrument1 GroundStation4)
	(calibration_target instrument1 GroundStation19)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star21)
	(supports instrument2 image0)
	(calibration_target instrument2 GroundStation13)
	(calibration_target instrument2 Star21)
	(calibration_target instrument2 GroundStation31)
	(calibration_target instrument2 Star8)
	(calibration_target instrument2 GroundStation7)
	(calibration_target instrument2 GroundStation27)
	(calibration_target instrument2 Star26)
	(calibration_target instrument2 Star6)
	(calibration_target instrument2 Star0)
	(calibration_target instrument2 Star16)
	(calibration_target instrument2 Star24)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star30)
	(supports instrument3 image0)
	(calibration_target instrument3 GroundStation11)
	(calibration_target instrument3 Star8)
	(calibration_target instrument3 GroundStation19)
	(calibration_target instrument3 Star22)
	(calibration_target instrument3 GroundStation27)
	(on_board instrument3 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Planet36)
	(supports instrument4 image0)
	(calibration_target instrument4 GroundStation20)
	(calibration_target instrument4 GroundStation27)
	(calibration_target instrument4 Star6)
	(calibration_target instrument4 Star18)
	(calibration_target instrument4 Star14)
	(calibration_target instrument4 Star0)
	(calibration_target instrument4 GroundStation3)
	(on_board instrument4 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Star30)
	(supports instrument5 image0)
	(calibration_target instrument5 GroundStation9)
	(calibration_target instrument5 Star22)
	(calibration_target instrument5 Star34)
	(calibration_target instrument5 Star2)
	(calibration_target instrument5 GroundStation32)
	(calibration_target instrument5 Star33)
	(calibration_target instrument5 Star21)
	(calibration_target instrument5 Star26)
	(calibration_target instrument5 Star17)
	(on_board instrument5 satellite5)
	(power_avail satellite5)
	(pointing satellite5 GroundStation23)
	(supports instrument6 image0)
	(calibration_target instrument6 GroundStation13)
	(calibration_target instrument6 Star15)
	(calibration_target instrument6 GroundStation23)
	(calibration_target instrument6 GroundStation3)
	(on_board instrument6 satellite6)
	(power_avail satellite6)
	(pointing satellite6 Star2)
)
(:goal (and
	(pointing satellite0 Phenomenon44)
	(pointing satellite1 GroundStation12)
	(pointing satellite4 GroundStation7)
	(pointing satellite5 Star43)
	(pointing satellite6 Star22)
	(have_image Planet35 image0)
	(have_image Planet36 image0)
	(have_image Star37 image0)
	(have_image Phenomenon38 image0)
	(have_image Phenomenon39 image0)
	(have_image Phenomenon40 image0)
	(have_image Planet41 image0)
	(have_image Planet42 image0)
	(have_image Star43 image0)
	(have_image Phenomenon44 image0)
))

)
